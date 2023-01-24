INPUT = flex_robot_language.l
OUTPUT = flex_robot_language.c
GCC_OUTPUT = flex_robot_language
TEST0 = test_robot_0.rl
TEST1 = test_robot_1.rl
TEST2 = test_robot_2.rl
ERROR_TEST = test_robot_error.rl

all:
	flex -o $(OUTPUT) $(INPUT)
	gcc $(OUTPUT) -o $(GCC_OUTPUT) -lfl
	./$(GCC_OUTPUT) $(TEST0)
	./$(GCC_OUTPUT) $(TEST1)
	./$(GCC_OUTPUT) $(TEST2)
	-./$(GCC_OUTPUT) $(ERROR_TEST)

clean:
	rm -f $(OUTPUT) $(GCC_OUTPUT)
