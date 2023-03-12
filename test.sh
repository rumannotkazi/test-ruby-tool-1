#!/bin/bash

# gemspec_dependencies=($(grep "^ *spec.add_development*" "tool-1.gemspec" | awk -F'[",]' '{print $2, $5, $8}' ))

# # Loop through the dependencies and check if they have a fixed version
# i=0
# for (( i=0; i<${#gemspec_dependencies[@]}; i+=2 )); do
#     # echo "GEMSPEC_DEPENDENCY = $dependency"
#     # Parse the dependency string to get the name and version
#     echo "i = $i"
#     name=$(echo "${gemspec_dependencies[i]}")
#     version=$(echo "${gemspec_dependencies[i+1]}" | awk '{print $1}')
#     echo "GEM: $name,   Version: $version "
#     # Check if the version has a fixed version
#     if [[ "$version" == "~>"* || "$version" == ">="* || "$version" == "<="* || "$version" == "<"* || "$version" == ">"* ]]; then
#     echo "Dependency ${name} does not have a fixed version"
#     fi
    

# done

echo "tool-1.gemspec:"

while read -r line; do
    echo "REPOSITORY BEING CHECKED : $repository" 
    if [[ $line == spec.add_*dependency* ]]; then
        dependency_type=""
        if [[ $line == spec.add_development* ]]; then
            dependency_type="Development"
        fi
        if [[ $line == spec.add_runtime* ]]; then
            dependency_type="Runtime"
        fi
        gem=$(echo "$line" | awk '{print $2}' | sed 's/"//g')
        state=$(echo "$line" | awk '{print $3}' | sed 's/[",]//g')
        version=$(echo "$line" | awk '{print $4}' | sed 's/[",]//g')
        echo "GEM: $gem State: $state, Version: $version"

        if [[ "$state" == "~>"* || "$state" == ">="* || "$state" == "<="* || "$state" == "<"* || "$state" == ">"* ]]; then
            echo -e "$dependency_type Dependency ${gem} does not have a fixed version\n "
            echo -e "::GEM:$gem Version:$version,  State:$state\n"
        fi
    fi


done < tool-1.gemspec