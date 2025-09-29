function numfiles
    # Use `find` to list all subdirectories and count files in each
    find * -maxdepth 0 -type d -exec sh -c "echo -n {} ' ' ; ls -lR {} | wc -l" \;
end
