#include <iostream>
#include <filesystem>
#include <queue>
using namespace std;
using namespace filesystem;
void copyFiles(const path& input, const path& output, int max_depth){
    queue<pair<path,int>> dirs;
    dirs.push({input,0});
    while (!dirs.empty()){
        auto [current, depth]=dirs.front();
        dirs.pop();
        for (const auto& entry:directory_iterator(current)){
            if (entry.is_directory()){
                if (max_depth==-1 || depth<max_depth)
                    dirs.push({entry.path(),depth+1});
            }else if(entry.is_regular_file()){
                string name=entry.path().filename().string();
                path dest=output/name;
                int counter=1;
                while (exists(dest)){
                    dest=output/(entry.path().stem().string()+"_"+to_string(counter++) +entry.path().extension().string());
                }
                copy(entry.path(),dest);
            }
        }
    }
}
int main(int argc, char* argv[]) {
    int max_depth=-1;
    path input,output;
    int shift=0;

    if (string(argv[1])=="--max_depth"){
        max_depth=stoi(argv[2]);
        shift=2;
    }
    input=argv[1 + shift];
    output=argv[2 + shift];
    create_directories(output);
    copyFiles(input,output, max_depth);
}

