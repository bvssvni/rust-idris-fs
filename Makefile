all: idrisfs

idrisfs:
	cargo rustc --release -- --emit=obj
	idris -i idris -i target/release idris/Main.idr -o idrisfs

clean:
	cargo clean
	rm idrisfs
	rm idris/Main.ibc
