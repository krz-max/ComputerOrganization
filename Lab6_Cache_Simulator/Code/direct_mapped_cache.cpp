#include "direct_mapped_cache.h"
#include "string"

using namespace std;
int power_of_two(int block_size)
{
    // block_size must be a power of 2
    int byte_offset = -1;
    while(block_size > 0)
    {
        block_size = block_size >> 1;
        byte_offset++;
    }
    return byte_offset;
}
float direct_mapped(string filename, int block_size, int cache_size)
{
    int total_num = 0;
    int hit_num = 0;
    
    /*write your code HERE*/
    ifstream f_in(filename.c_str());
    string address;
    int byte_offset = power_of_two(block_size);
    int index_range = cache_size / block_size;
    int index_bits = power_of_two(index_range);
    int cache_array[index_range]; // stores tag of each address
    while(f_in >> address)
    {
        total_num++;
        unsigned int addr = strtoul(address.c_str(), NULL, 16); // hex string to unsigned int
        unsigned int index = (addr >> byte_offset) % index_range;
        unsigned int tag = addr >> (byte_offset + index_bits);
        if(cache_array[index] == tag)
        {
            hit_num++;
        }
        else
        {
            cache_array[index] = tag;
        }
    }
    f_in.close();
    return (float)hit_num/total_num;
}
