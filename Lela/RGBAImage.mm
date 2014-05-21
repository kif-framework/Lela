/*
RGBAImage.cpp
Copyright (C) 2006 Yangli Hector Yee

(This entire file was rewritten by Jim Tilander)

This program is free software; you can redistribute it and/or modify it under the terms of the
GNU General Public License as published by the Free Software Foundation; either version 2 of the License,
or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program;
if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
*/

#include "RGBAImage.h"
#include <cstdio>
#include <cstring>

RGBAImage* RGBAImage::DownSample() const {
   if (Width <=1 || Height <=1) return NULL;
   int nw = Width / 2;
   int nh = Height / 2;
   RGBAImage* img = new RGBAImage(nw, nh, Name.c_str());
   for (int y = 0; y < nh; y++) {
      for (int x = 0; x < nw; x++) {
         int d[4];
         // Sample a 2x2 patch from the parent image.
         d[0] = Get(2 * x + 0, 2 * y + 0);
         d[1] = Get(2 * x + 1, 2 * y + 0);
         d[2] = Get(2 * x + 0, 2 * y + 1);
         d[3] = Get(2 * x + 1, 2 * y + 1);
         int rgba = 0;
         // Find the average color.
         for (int i = 0; i < 4; i++) {
            int c = (d[0] >> (8 * i)) & 0xFF;
            c += (d[1] >> (8 * i)) & 0xFF;
            c += (d[2] >> (8 * i)) & 0xFF;
            c += (d[3] >> (8 * i)) & 0xFF;
            c /= 4;
            rgba |= (c & 0xFF) << (8 * i);
         }
         img->Set(x, y, rgba);
      }
   }
   return img;
}

bool RGBAImage::WriteToFile(const char* filename)
{
    UIImage *image = Get_UIImage();
    
    NSData *data = UIImagePNGRepresentation(image);
    if (!data) {
        printf("Could not write data.");
        return false;
    }
    
    NSString *fileName = [NSString stringWithFormat:@"%s.png", filename];
    BOOL result = [data writeToFile:fileName atomically:YES];
	if(!result)
		printf("Failed to save to %s.png\n", filename);
	return result;
}

RGBAImage* RGBAImage::ReadFromFile(const char* filename)
{
    NSString *fileName = [NSString stringWithUTF8String:filename];
    UIImage *image = [UIImage imageWithContentsOfFile:fileName];
    
    if (image == nil) {
        printf("Could not open file %s\n", filename);
        return 0;
    }
    
    return ReadFromUIImage(image);
}

UIImage *RGBAImage::Get_UIImage()
{
    CGContextRef context = CreateContext();
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    UIImage *image = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGContextRelease(context);
    return image;
}

RGBAImage* RGBAImage::ReadFromUIImage(UIImage *image)
{
    CGImageRef imageRef = [image CGImage];
    
	const int w = (int)CGImageGetWidth(imageRef);
	const int h = (int)CGImageGetHeight(imageRef);
    
	RGBAImage* result = new RGBAImage(w, h, NULL);
    
    CGContextRef context = result->CreateContext();
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), imageRef);
    CGContextRelease(context);
    
	return result;
}

CGContextRef RGBAImage::CreateContext()
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * Width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(Data, Width, Height,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    return context;
}


