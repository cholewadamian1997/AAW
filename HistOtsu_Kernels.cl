
/*
void array_splitter_left(float* left_split, float* entry_array, int index)
{
	for(int i=0;i<index;i++)
	{
		left_split[i]=entry_array[i];
	}
}

void array_splitter_right(float* right_split, float* entry_array, int index,uint size)
{
	for(int i=index;i<size;i++)
	{
		left_split[i-index]=entry_array[i];
	}
}*/


__kernel void hist_to_otsu(__global uint* Histogram, __global uint otsuThresh) //pojedynczy work item na ca³y kernel i ca³y wektor wejsciowy, czy zadzia³a?
{

	uint hist_size = 256;
	uint otsu=0;
	float continue_condition = 0.00000001;
	
	float* hist_norm[hist_size]={0};
	uint hist_sum = 0;
	for(int i=0;i<size;i++)
	{
		hist_sum+=Histogram[i];
	}
	
	for(int i=0;i<size;i++)
	{
		hist_norm[i]=Histogram[i]/hist_sum;
	}

	float* hist_cumulative[hist_size]={0};
	float hist_sum_cumulative=0;
	
	for(int i=0;i<size;i++)
	{
		hist_sum_cumulative+=hist_norm[i];
		hist_cumulative[i]=hist_sum_cumulative;
	}
	
	float fn_min = INFINITY;
	int index = 0;
	for(int i=1;i<size;i++)
	{
		/*
		float* p1[i]={0};
		float* p2[size-i]={0};
		array_splitter_left(p1, hist_norm , i);
		array_splitter_right(p2, hist_norm , i, hist_size);
		*/
		float m1,m2,v1,v2,fn=0;
		float q1=hist_cumulative[i];
		float q2=hist_cumulative[hist_size-1]-hist_cumulative[i];
		if (q1 < continue_condition || q2 < continue_condition)
			continue;
		for(int j=0;j<i;j++)
			{
				m1+=hist_norm[j]*j/q1;
			}
		for(int k=i;k<size;k++)
			{
				m2+=hist_norm[k]*k/q2;
			}
		for(int j=0;j<i;j++)
			{
				v1+=(j-m1)*(j-m1)*hist_norm[j]/q1;
			}
		for(int k=i;k<size;k++)
			{
				v2+=(k-m2)*(k-m2)*hist_norm[k]/q2;
			}
		fn = v1*q1+v2*q2;
		if(fn<fn_min)
		{
			fn_min=fn;
			index = i;
		}
	}
	otsuThresh = index;
}

	

	 






	

	




	

	

	
	
