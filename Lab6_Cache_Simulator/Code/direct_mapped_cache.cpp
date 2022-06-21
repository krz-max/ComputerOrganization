#include <fstream>
#include <cstring>
#include <cmath>
#include "direct_mapped_cache.h"
#include "string"

using namespace std;

string hex2bin(string);
int bin2dec(string);
struct cache{
    bool valid;
    string tag;
    cache(){ valid = false;}
};
float direct_mapped(string filename, int block_size, int cache_size)
{
    int total_num = 0;
    int hit_num = 0;
    
    /*write your code HERE*/
    fstream inf;
    inf.open(filename);
    string address, address_bin, index_bin, tag;
    struct cache *direct_mapped_cache = new cache [cache_size/block_size];
    int tag_bitNum=0, offset_bitNum=0, index_bitNum=0, index_dec;

    offset_bitNum = log2(block_size);
    index_bitNum = log2(cache_size/block_size);

    while(getline(inf, address)){
        //cout<< "cache_size:    "<< cache_size<< endl;//  
        //cout<< "block_size:    "<< block_size<< endl;//
        //cout<< "index_bitNum:  "<< index_bitNum<< endl;//
        //cout<< "offset_bitNum: "<< offset_bitNum<< endl;//
        tag_bitNum = 32-index_bitNum-offset_bitNum;
        //cout<< "tag_bitNum:    "<< tag_bitNum<< endl;//
        
        //cout<< "address:       "<< address <<endl;//
        address_bin = hex2bin(address);    
        //cout<< address_bin <<endl;//

        //00 000 00
        for(int i= offset_bitNum; i< offset_bitNum+index_bitNum; i++) 
            index_bin += address_bin[i];
        for(int i= offset_bitNum+index_bitNum; i< address_bin.length(); i++) 
            tag += address_bin[i];
        //cout<< "index_bin: "<< index_bin<< endl;//
        index_dec = bin2dec(index_bin);
        //cout<< "index_dec: "<< index_dec<< endl;//
        //cout<< "tag:       "<< tag<<endl;//

        if(direct_mapped_cache[index_dec].valid==true && 
           strcmp(tag.c_str(), direct_mapped_cache[index_dec].tag.c_str())==0) 
           hit_num++;
        else{
            direct_mapped_cache[index_dec].valid = true;
            direct_mapped_cache[index_dec].tag = tag;
        }

        index_bin.clear();
        tag.clear();
        total_num++;
        //cout<< endl;
    }
  
    return (float)hit_num/total_num;
}
int bin2dec(string bin){
    int i=0, dec=0, base=1;

    while(i < bin.length()){
        dec += base*(bin[i]-48); //ascii code of 0 is 48
        base*=2;
        i++;
    }

    return dec;
}
string hex2bin(string hex)
{
    string bin;
    int i=hex.length()-1;

    //e.g.MSB bf979d20 LSB(index0)
    while(i > -1){
        switch(hex[i--]){
            case '0': bin += "0000"; break;//index3 0000 index0
            case '1': bin += "1000"; break;//0001
            case '2': bin += "0100"; break;//0010
            case '3': bin += "1100"; break;//0011
            case '4': bin += "0010"; break;//0100
            case '5': bin += "1010"; break;//0101
            case '6': bin += "0110"; break;//0110   
            case '7': bin += "1110"; break;//0111 
            case '8': bin += "0001"; break;//1000
            case '9': bin += "1001"; break;//1001
            case 'a': bin += "0101"; break;//1010
            case 'b': bin += "1101"; break;//1011
            case 'c': bin += "0011"; break;//1100
            case 'd': bin += "1011"; break;//1101
            case 'e': bin += "0111"; break;//1110
            case 'f': bin += "1111"; break;//1111 
        }
    }
    while(bin.length() < 32) bin += '0';

    return bin;
}
