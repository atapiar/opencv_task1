#include <iostream>
#include <opencv2/opencv.hpp>
#include <opencv2/core/cuda.hpp>
#include <opencv2/cudaimgproc.hpp>
#include <opencv2/cudawarping.hpp>

using namespace cv;
using namespace std;

__global__ void templateMatching(const cv::cuda::PtrStepSz<float> img, const cv::cuda::PtrStepSz<float> templ, cv::cuda::PtrStepSz<float> result) {
    int x = threadIdx.x + blockIdx.x * blockDim.x;
    int y = threadIdx.y + blockIdx.y * blockDim.y;

    if (x >= img.cols - templ.cols || y >= img.rows - templ.rows)
        return;

    float sum = 0.0f;
    for (int i = 0; i < templ.rows; ++i) {
        for (int j = 0; j < templ.cols; ++j) {
            sum += powf(img.ptr(y + i)[x + j] - templ.ptr(i)[j], 2);
        }
    }
    result.ptr(y)[x] = sum;
}

int main() {
    // Load input image and template
    Mat img = imread("input_image.jpg", IMREAD_GRAYSCALE);
    Mat templ = imread("template_image.jpg", IMREAD_GRAYSCALE);

    if (img.empty() || templ.empty()) {
        cerr << "Error: Couldn't load image(s)." << endl;
        return -1;
    }

    // Convert input image and template to float
    img.convertTo(img, CV_32F);
    templ.convertTo(templ, CV_32F);

    // Allocate memory on GPU
    cuda::GpuMat gpuImg(img);
    cuda::GpuMat gpuTempl(templ);
    cuda::GpuMat gpuResult(img.rows - templ.rows + 1, img.cols - templ.cols + 1, CV_32F);

    // Define block and grid dimensions
    dim3 block(16, 16);
    dim3 grid((img.cols - templ.cols + block.x - 1) / block.x, (img.rows - templ.rows + block.y - 1) / block.y);

    // Perform template matching on GPU
    templateMatching<<<grid, block>>>(gpuImg, gpuTempl, gpuResult);

    // Download result from GPU
    Mat result;
    gpuResult.download(result);

    // Find minimum and maximum values in the result
    double minVal, maxVal;
    Point minLoc, maxLoc;
    minMaxLoc(result, &minVal, &maxVal, &minLoc, &maxLoc);

    // Display the result
    rectangle(img, maxLoc, Point(maxLoc.x + templ.cols, maxLoc.y + templ.rows), Scalar::all(255), 2);
    imshow("Result", img);
    waitKey(0);

    return 0;
}
