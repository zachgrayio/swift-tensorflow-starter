import TensorFlow

func product() -> Tensor<Float> {
    let t = Tensor<Float>([1.2, 0.8])
    let product = t * t
    return product
}