__kernel void final_histogram(  __global *partial_histogram,
								__global uint *histogram,
								unsigned int num_of_hist) {

	int GID = get_global_id(0);
	int group_indx;
	int n = num_of_hist;
	local uint tmp_histogram[256];
	
	tmp_histogram[GID] = partial_histogram[GID];
	group_indx = 256;
	while (n > 0) {
		tmp_histogram[GID] += partial_histogram[group_indx + GID];
		group_indx += 256;
		n--;
	}
	histogram[GID] = tmp_histogram[GID];
}