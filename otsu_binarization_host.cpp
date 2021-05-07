/**********************************************************************
Host program for Otsu binarization using OpenCL

Damian Cholewa
Michał Knap
Michał Mróz

**********************************************************************/

/*#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <string.h>
#include "CLUtil.hpp"

cl_uint numPlatforms;	//the NO. of platforms
cl_platform_id platform = NULL;	//the chosen platform
cl_int	status = clGetPlatformIDs(0, NULL, &numPlatforms);
if (status != CL_SUCCESS)
{
	cout << "Error: Getting platforms!" << endl;
	return FAILURE;
}


    cl_int status = 0;
    // Allocate host memory and read input image
    std::string filePath = getPath() + std::string(INPUT_IMAGE);
    status = readInputImage(filePath);
    CHECK_ERROR(status, SDK_SUCCESS, "Read InputImage failed");
*/  
    
#include <ctime>
#include <fstream>
#include <iostream>
#include <exception>

#define __CL_ENABLE_EXCEPTIONS
#define __NO_STD_VECTOR

#include <CL/opencl.h>
#include <CL/cl.hpp>

/* Kod funkcjji convertToString z materiałów do kursu AAW */
int convertToString(const char *filename, std::string& s)
{
	size_t size;
	char*  str;
	std::fstream f(filename, (std::fstream::in | std::fstream::binary));

	if(f.is_open())
	{
		size_t fileSize;
		f.seekg(0, std::fstream::end);
		size = fileSize = (size_t)f.tellg();
		f.seekg(0, std::fstream::beg);
		str = new char[size+1];
		if(!str)
		{
			f.close();
			return 0;
		}

		f.read(str, fileSize);
		f.close();
		str[size] = '\0';
		s = str;
		delete[] str;
		return 0;
	}
	cout<<"Error: failed to open file\n:"<<filename<<endl;
	return FAILURE;
}


int N = 16;
const char* kernelSource;
int i;

cl::vector<cl::Platform> platforms;
cl::vector<cl::Device> devices;
cl::vector<cl::Kernel> allKernels;

cl_int cli_err;

/* DEKLARACJA TABLIC NA OBRAZY, HISTO ???? */

int main(int argc, char* argv[]){
	try {
		
		/*	tab - obraz 
			tab - hist 
		*/	
		
		cl::Platform::get(&platforms);
		
		platforms[0].getDevices(CL_DEVICE_TYPE_GPU, &devices);
		cl_context_properties properties[] = {CL_CONTEXT_ PLATFOR, (cl_context_properties)(platforms[0])(), 0};
		
		cl::Context context(CL_DEVICE_TYPE_GPU, properties);
		cl::vector<cl::Device> devices = context.getInfo <CL_CONTEXT_DEVICES>();
		cl::Program::Sources source(1, std::make_pair(kernelSource, strlen(kernelSource)));
		
		cl::Program program = cl::Program(context, source);
		
		program.build(devices);
		
		
		cl::Kernel kernel(program, ”NAZWA PROGRAMU”, &cli_err);
		/* ODPOWIEDNIE DL ANASZYCH TABLIC 
		cl::Buffer device_in_a( context, CL_MEM_READ_ONLY, N*sizeof(float));
		cl::Buffer device_in_b( context, CL_MEM_READ_ONLY, N*sizeof(float));
		cl::Buffer device_out_c( context,CL_MEM_WRITE_ONLY, N*sizeof(float));
		*/
		
		cl::Event event;
		
		cl::CommandQueue queue(contex, devices[0], 0, &cli_err);
		
		/*
		queue.enqueueWriteBuffer(device_in_a, true, 0, N*sizeof(N), (void*)host_in_a);
		
		queue.enqueueWriteBuffer(device_in_b, true, 0, N*sizeof(N), (void*)host_in_b);
		*/
		
		kernel.setArg(0, device_in_a );
		kernel.setArg(1, device_in_b );
		kernel.setArg(2, device_out_c );
		kernel.setArg(3, sizeof(int), (void*)&N);
		
		queue.enqueueNDRangeKernel( kernel, cl::NullRange, cl::NDRange(N,1), cl::NullRange, NULL, &event);
		
		event.wait();
		
		queue.enqueueReadBuffer(device_out_c, true, 0, N*sizeof(float), (void*)host_out_c);
	}
	
	catch(cl::Error e) {
		std::cout << e.what() << ”: Errorcode ” << e.err() << std::endl;
	}
	
	return 0
}
