CFMLC = cfmlc
COQC = coqc
NAME = Tutorial

all: $(NAME)_proof.vo

$(NAME)_ml.v: $(NAME).ml
	$(CFMLC) $(NAME).ml

%.vo: %.v
	$(COQC) $<
$(NAME)_ml.vo: $(NAME)_ml.v
$(NAME)_proof.vo: $(NAME)_ml.vo $(NAME)_proof.v

# Clean up generated files
clean:
	rm -f *.cmj *.vo *.vos *.vok *.glob $(NAME)_ml.v
	rm -rf _output
	find . \( -name ".*.aux" -o -name ".*.cache" \) -type f -delete

.PHONY: all clean
