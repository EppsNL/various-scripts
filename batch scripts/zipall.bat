::Zips subdirectories in folder where bat is ran to their own zip file
for /d %%X in (*) do "%ProgramFiles%\7-Zip\7z.exe" a "%%X.zip" "%%X\"