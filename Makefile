NAME=palindromic

all: clean compile reverse xxd run shasum
	@echo "Done!"

compile:
	nasm elf.asm -f bin -o $(NAME)
	chmod +x $(NAME)

reverse:
	python3 reverse_bytes.py
	chmod +x palindromic_reversed

xxd:
	xxd palindromic
	@echo "--------------------------------------------------------------------------"
	xxd palindromic_reversed

run:
	@echo "Original:"
	./palindromic
	@echo "Reversed:"
	./palindromic_reversed

shasum:
	sha256sum palindromic
	sha256sum palindromic_reversed

clean:
	@echo "Cleaning..."
	rm -f $(NAME) palindromic_reversed
	@echo "Done!"
