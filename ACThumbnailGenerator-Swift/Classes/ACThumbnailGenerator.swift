
import AVKit
import AVFoundation

public protocol ACThumbnailGeneratorDelegate: class {
    func generator(_ generator: ACThumbnailGenerator, didCapture image: UIImage, at position: Double)
}

public class ACThumbnailGenerator: NSObject {
    private(set) var preferredBitrate: Double
    private(set) var streamUrl: URL
    private(set) var queue: [Double] = []
    
    private var player: AVPlayer?
    private var videoOutput: AVPlayerItemVideoOutput?
    
    var loading = false
    public weak var delegate: ACThumbnailGeneratorDelegate?
    
    public init(streamUrl: URL, preferredBitrate: Double = 0.0) {
        self.streamUrl = streamUrl
        self.preferredBitrate = preferredBitrate
    }
    
    deinit {
        clear()
    }
    
    private func prepare(completionHandler: @escaping () -> Void) {
        let asset = AVAsset(url: streamUrl)
        let keys = ["playable", "tracks", "duration"]
        asset.loadValuesAsynchronously(forKeys: keys) { [weak self] in
            let playerItem = AVPlayerItem(asset: asset)
            playerItem.preferredPeakBitRate = self?.preferredBitrate ?? 1000000
            
            DispatchQueue.main.async {
                let settings = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]
                self?.videoOutput = AVPlayerItemVideoOutput.init(pixelBufferAttributes: settings)
                if let videoOutput = self?.videoOutput {
                    playerItem.add(videoOutput)
                }
                
                self?.player = AVPlayer(playerItem: playerItem)
                self?.player?.currentItem?.addObserver(self!, forKeyPath: "status", options: [], context: nil)
                
                completionHandler()
            }
        }
    }
    
    private func clear() {
        if let player = player {
            player.currentItem?.removeObserver(self, forKeyPath: "status")
            player.pause()
            if let videoOutput = videoOutput {
                player.currentItem?.remove(videoOutput)
                self.videoOutput = nil
            }
            player.currentItem?.asset.cancelLoading()
            player.cancelPendingPrerolls()
            player.replaceCurrentItem(with: nil)
            self.player = nil
        }
    }
    
    public func replaceStreamUrl(newUrl url: URL) {
        streamUrl = url
        clear()
    }
    
    public func captureImage(at position: Double) {
        guard !loading else {
            // If loading, queue new request
            if let index = queue.firstIndex(of: position) {
                queue.remove(at: index)
            }
            queue.append(position)
            return
        }
        loading = true
        
        if player == nil {
            prepare { [weak self] in
                self?.seek(to: position)
            }
        }
        else {
            seek(to: position)
        }
    }
    
    private func seek(to position: Double) {
        let timeScale = self.player?.currentItem?.asset.duration.timescale ?? 0
        
        let targetTime = CMTimeMakeWithSeconds(position, preferredTimescale: timeScale)
        if CMTIME_IS_VALID(targetTime) {
            self.player?.seek(to: targetTime)
        }
    }
    
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard
            let videoOutput = self.videoOutput,
            let currentItem = self.player?.currentItem,
            currentItem.status == .readyToPlay
            else {
                return
        }
        
        let currentTime = currentItem.currentTime()
        if let buffer = videoOutput.copyPixelBuffer(forItemTime: currentTime, itemTimeForDisplay: nil) {
            let ciImage = CIImage(cvPixelBuffer: buffer)
            let imgRect = CGRect(x: 0, y: 0, width: CVPixelBufferGetWidth(buffer), height: CVPixelBufferGetHeight(buffer))
            if let videoImage = CIContext().createCGImage(ciImage, from: imgRect) {
                let image = UIImage.init(cgImage: videoImage)
                delegate?.generator(self, didCapture: image, at: CMTimeGetSeconds(currentTime))
                
                loading = false
                
                // Capture the next position in the queue
                if !queue.isEmpty {
                    let position = queue.removeFirst()
                    captureImage(at: position)
                }
            }
        }
    }
}
