#include <random>
#include <iostream>

static int seed;

void setseed(int setnum){
    seed = setnum;
}

double getRand(const double& A, const double& B) {
    static std::mt19937 twister(seed);
    static std::uniform_real_distribution<double> dist;

    //printf("seed %d¥n",seed);
    dist.param(std::uniform_real_distribution<double>::param_type(A, B));
    return dist(twister);
}

int getIntRand(const int& A, const int& B) {
    static std::mt19937 twister(seed);
    static std::uniform_int_distribution<int> dist;

    dist.param(std::uniform_int_distribution<int>::param_type(A, B));
    return dist(twister);
}
