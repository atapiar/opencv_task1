#include <opencv2/highgui.hpp>
#include "opencv2/imgproc.hpp"
#include <iostream>

using namespace cv;
using namespace std;

int main( int argc, char** argv )
{
    double alpha = 0.5; double beta; double input;

    Mat dst2;

    Mat image;
    image = imread("lena.png", IMREAD_COLOR);

    CommandLineParser parser( argc, argv, "{@input | lena.png | input image}" );
    Mat src = imread( samples::findFile( parser.get<String>( "@input" ) ), IMREAD_COLOR );

    Mat src2 = imread( samples::findFile("logo-only1.png") );
    beta = ( 1.0 - alpha );
    addWeighted( src, alpha, src2, beta, 0.0, dst2);
    

    if (image.empty())
    {
        cout << "Could not open or find the image" << endl;
        cin.get(); //wait for any key press
        return -1;
    }

    cvtColor( src, src, COLOR_BGR2GRAY );

    Mat imageBrighnessHigh100;
    image.convertTo(imageBrighnessHigh100, -1, 1, 100); //increase the brightness by 100

    Mat imageContrastHigh4;
    image.convertTo(imageContrastHigh4, -1, 4, 0); //increase the contrast by 4

    Mat dst;
    equalizeHist( src, dst );


    //Defining window names for above images
    String windowNameOriginalImage = "Original Image";
    String windowNameWithBrightnessHigh100 = "Brightness Increased by 100";
    String windowNameContrastHigh4 = "Contrast Increased by 4";

    //Create and open windows for above images
    namedWindow(windowNameOriginalImage, WINDOW_NORMAL);
    namedWindow(windowNameWithBrightnessHigh100, WINDOW_NORMAL);
    namedWindow(windowNameContrastHigh4, WINDOW_NORMAL);

    //Show above images inside the created windows.
    imshow(windowNameOriginalImage, image);
    imshow(windowNameWithBrightnessHigh100, imageBrighnessHigh100);
    imshow(windowNameContrastHigh4, imageContrastHigh4);

    imshow( "Source image", src );
    imshow( "Equalized Image", dst );

    imshow( "Linear Blend", dst2 );

    waitKey(0); // Wait for any key stroke

    destroyAllWindows(); //destroy all open windows

    return 0;
}