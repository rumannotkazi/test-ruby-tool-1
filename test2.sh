has_fixed_versions=true
for repository in $repositories_col; do
    git clone "https://github.com/$repository.git"
    cd "$(basename "$repository" .git)"
    gemspec_file=$(find . -type f -name '*.gemspec' -print -quit)
    if [[ -z $gemspec_file ]]; then
        echo "No .gemspec file found in $repository"
        exit 1
    fi
    gemspec_dependencies=($(grep "^ *spec.add_*" "$gemspec_file" | awk '{print $2, $3, $5}'))

    echo -e "GEMSPEC file being checked: $gemspec_file\n"

    while read -r line; do
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

            if [[ "$state" == "~>"* || "$state" == ">="* || "$state" == "<="* || "$state" == "<"* || "$state" == ">"* ]]; then
                echo -e "$repository: $dependency_type Dependency '${gem}' does not have a fixed version "
                echo -e " -> GEM:$gem State:$state, Version:$version\n"
                has_fixed_versions=false
            fi
        fi
    done < $gemspec_file
    cd ..
    rm -rf "$(basename "$repository" .git)"
    echo -e "--------------------------------------------\n"
done
