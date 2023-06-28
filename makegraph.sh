make
./build/Cry test/test.cry test/out.dot
dot -Tpng test/out.dot -o test/out.png
