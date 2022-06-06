#include "set_associative_cache.h"
#include "string"

using namespace std;
int power_of_two_u(int block_size)
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
float set_associative(string filename, int way, int block_size, int cache_size)
{
    int total_num = 0;
    int hit_num = 0;

    /*write your code HERE*/
    ifstream f_in(filename.c_str());
    ofstream f_out("debug.txt");
    string address;
    int byte_offset = power_of_two_u(block_size);
    int index_range = cache_size / (block_size*way); // index_range = cache_size / (size of set = block_size*# of ways)
    int index_bits = power_of_two_u(index_range);
    int cache_array[index_range][way]; // stores tag of each address, each set has (#way) block
    int used_block[index_range]; // stores the number of used blocks in each set
    for(int i = 0; i < index_range; i++) used_block[i] = 0;
    while(f_in >> address)
    {
        total_num++;
        bool hit = false;
        unsigned int addr = strtoul(address.c_str(), NULL, 16); // hex string to unsigned int
        unsigned int index = (addr >> byte_offset) % index_range;
        unsigned int tag = addr >> (byte_offset + index_bits);
        for(int i = 0; i < used_block[index]; i++)
        {
            if(cache_array[index][i] == tag)
            {
                for(int j = i; j < used_block[index]-1; j++){
                    cache_array[index][j] = cache_array[index][j+1];
                }
                cache_array[index][used_block[index]-1] = tag;
                hit_num++;
                hit = true;
                break;
            }
        }
        if(!hit)
        {
            if(used_block[index] == way){
                for(int j = 0; j < way-1; j++){
                    cache_array[index][j] = cache_array[index][j+1];
                }
                cache_array[index][way-1] = tag;
            }
            else{
                cache_array[index][used_block[index]] = tag;
                used_block[index]++;
            }
        }
    }
    f_in.close();
    return (float)hit_num/total_num;
}
