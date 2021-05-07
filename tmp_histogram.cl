// program do wyznaczenia histogramu częściowego
// rozmiar siatki roboczej - ilosc czesci
// histogram obrazu = suma histrogramów czesciowych

// pragma aby umozliwic używanie funkcji atomicznych
#pragma OPENCL EXTENSION 
cl_khr_local_int32_base_atomics : enable

__kernel void histogram(__global uint* in_data, __global uint* partial_histogram, unsigned int N )
{
	int LID = get_local_id(0);				// identyfikator elementu w określonej grupie roboczej
	int GID = get_global_id(0);				// globalny identyikator dla elementow przydzielonych do kernela
	int local_size = get_local_size(0);		// liczba lokalnych elementów roboczych
	int GRPIDX = get_group_id(0) * 256;		// id grupy roboczej

	local uint tmp_histogram[256];			//tymczasowy histogram
	int j = 256;
	int indx = 0;

	// dla pewnosci zerujemy wartosci w histogramie
	for( j=256; j > 0; j-=local_size,indx+=local_size){
		if (LID < j)						// warunek aby nie bylo kolizji
			tmp_histogram[indx+LID] = 0;
	}
	barrier(CLK_LOCAL_MEM_FENCE);			// czekamy az wszystkie jednostki robocze w grupie wyzeruja tab
	

	// wszsytkie jednostki robocze inkremetuja wartosc historgramu dla danej wartosci z obrazu 
	if (GID < N){
		uint value = in_data[GID];
		atom_inc(&tmp_histogram[value]);
	}
	barrier(CLK_LOCAL_MEM_FENCE);
	

	// prznosimy tymczasowy hist do hist czsciowego (pamiec globalna)
	for( j=256, indx=0 ; j > 0 ; j-=local_size, indx+=local_size){
		if (LID < j)
			partial_histogram[GRPIDX + indx + LID] += tmp_histogram[indx + LID];
	}
}

