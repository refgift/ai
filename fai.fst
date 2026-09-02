BEGIN
	INTEGER FEED;

	INTEGER A;
	INTEGER B;

	A := -1;
	B := -1;	

	DENOTED OUTNESS;

	FEED := RANDOM;
	IF FEED < 0 THEN FEED := FEED * -1;
	FEED := FEED % 10;
	IF A = -1 THEN A := FEED;

	FEED := RANDOM;
	IF FEED < 0 THEN FEED := FEED * -1;
	FEED := FEED % 10;
	IF B = -1 THEN B := FEED;

	IF A > -1 THEN
	IF B > -1 THEN
			BEGIN
				IF A = 0 THEN
				BEGIN
					IF B = 0 THEN OUTNESS := "0OR0";
					IF B = 1 THEN OUTNESS := "0OR1";
					IF B = 2 THEN OUTNESS := "0OR2";
					IF B = 3 THEN OUTNESS := "0OR3";
					IF B = 4 THEN OUTNESS := "0OR4";
					IF B = 5 THEN OUTNESS := "0OR5";
					IF B = 6 THEN OUTNESS := "0OR6";
					IF B = 7 THEN OUTNESS := "0OR7";
					IF B = 8 THEN OUTNESS := "0OR8";
					IF B = 9 THEN OUTNESS := "0OR9";
				END
				IF A = 1 THEN
				BEGIN
					IF B = 0 THEN OUTNESS := "1OR0";
					IF B = 1 THEN OUTNESS := "1OR1";
					IF B = 2 THEN OUTNESS := "1OR2";
					IF B = 3 THEN OUTNESS := "1OR3";
					IF B = 4 THEN OUTNESS := "1OR4";
					IF B = 5 THEN OUTNESS := "1OR5";
					IF B = 6 THEN OUTNESS := "1OR6";
					IF B = 7 THEN OUTNESS := "1OR7";
					IF B = 8 THEN OUTNESS := "1OR8";
					IF B = 9 THEN OUTNESS := "1OR9";
				END
				IF A = 2 THEN
				BEGIN
					IF B = 0 THEN OUTNESS := "2OR0";
					IF B = 1 THEN OUTNESS := "2OR1";
					IF B = 2 THEN OUTNESS := "2OR2";
					IF B = 3 THEN OUTNESS := "2OR3";
					IF B = 4 THEN OUTNESS := "2OR4";
					IF B = 5 THEN OUTNESS := "2OR5";
					IF B = 6 THEN OUTNESS := "2OR6";
					IF B = 7 THEN OUTNESS := "2OR7";
					IF B = 8 THEN OUTNESS := "2OR8";
					IF B = 9 THEN OUTNESS := "2OR9";
				END
				IF A = 3 THEN
				BEGIN
					IF B = 0 THEN OUTNESS := "3OR0";
					IF B = 1 THEN OUTNESS := "3OR1";
					IF B = 2 THEN OUTNESS := "3OR2";
					IF B = 3 THEN OUTNESS := "3OR3";
					IF B = 4 THEN OUTNESS := "3OR4";
					IF B = 5 THEN OUTNESS := "3OR5";
					IF B = 6 THEN OUTNESS := "3OR6";
					IF B = 7 THEN OUTNESS := "3OR7";
					IF B = 8 THEN OUTNESS := "3OR8";
					IF B = 9 THEN OUTNESS := "3OR9";
				END
				IF A = 4 THEN
				BEGIN
					IF B = 0 THEN OUTNESS := "4OR0";
					IF B = 1 THEN OUTNESS := "4OR1";
					IF B = 2 THEN OUTNESS := "4OR2";
					IF B = 3 THEN OUTNESS := "4OR3";
					IF B = 4 THEN OUTNESS := "4OR4";
					IF B = 5 THEN OUTNESS := "4OR5";
					IF B = 6 THEN OUTNESS := "4OR6";
					IF B = 7 THEN OUTNESS := "4OR7";
					IF B = 8 THEN OUTNESS := "4OR8";
					IF B = 9 THEN OUTNESS := "4OR9";
				END
				IF A = 5 THEN
				BEGIN
					IF B = 0 THEN OUTNESS := "5OR0";
					IF B = 1 THEN OUTNESS := "5OR1";
					IF B = 2 THEN OUTNESS := "5OR2";
					IF B = 3 THEN OUTNESS := "5OR3";
					IF B = 4 THEN OUTNESS := "5OR4";
					IF B = 5 THEN OUTNESS := "5OR5";
					IF B = 6 THEN OUTNESS := "5OR6";
					IF B = 7 THEN OUTNESS := "5OR7";
					IF B = 8 THEN OUTNESS := "5OR8";
					IF B = 9 THEN OUTNESS := "5OR9";
				END
				IF A = 6 THEN
				BEGIN
					IF B = 0 THEN OUTNESS := "6OR0";
					IF B = 1 THEN OUTNESS := "6OR1";
					IF B = 2 THEN OUTNESS := "6OR2";
					IF B = 3 THEN OUTNESS := "6OR3";
					IF B = 4 THEN OUTNESS := "6OR4";
					IF B = 5 THEN OUTNESS := "6OR5";
					IF B = 6 THEN OUTNESS := "6OR6";
					IF B = 7 THEN OUTNESS := "6OR7";
					IF B = 8 THEN OUTNESS := "6OR8";
					IF B = 9 THEN OUTNESS := "6OR9";
				END
				IF A = 7 THEN
				BEGIN
					IF B = 0 THEN OUTNESS := "7OR0";
					IF B = 1 THEN OUTNESS := "7OR1";
					IF B = 2 THEN OUTNESS := "7OR2";
					IF B = 3 THEN OUTNESS := "7OR3";
					IF B = 4 THEN OUTNESS := "7OR4";
					IF B = 5 THEN OUTNESS := "7OR5";
					IF B = 6 THEN OUTNESS := "7OR6";
					IF B = 7 THEN OUTNESS := "7OR7";
					IF B = 8 THEN OUTNESS := "7OR8";
					IF B = 9 THEN OUTNESS := "7OR9";
				END
				IF A = 8 THEN
				BEGIN
					IF B = 0 THEN OUTNESS := "8OR0";
					IF B = 1 THEN OUTNESS := "8OR1";
					IF B = 2 THEN OUTNESS := "8OR2";
					IF B = 3 THEN OUTNESS := "8OR3";
					IF B = 4 THEN OUTNESS := "8OR4";
					IF B = 5 THEN OUTNESS := "8OR5";
					IF B = 6 THEN OUTNESS := "8OR6";
					IF B = 7 THEN OUTNESS := "8OR7";
					IF B = 8 THEN OUTNESS := "8OR8";
					IF B = 9 THEN OUTNESS := "8OR9";
				END
				IF A = 9 THEN
				BEGIN
					IF B = 0 THEN OUTNESS := "9OR0";
					IF B = 1 THEN OUTNESS := "9OR1";
					IF B = 2 THEN OUTNESS := "9OR2";
					IF B = 3 THEN OUTNESS := "9OR3";
					IF B = 4 THEN OUTNESS := "9OR4";
					IF B = 5 THEN OUTNESS := "9OR5";
					IF B = 6 THEN OUTNESS := "9OR6";
					IF B = 7 THEN OUTNESS := "9OR7";
					IF B = 8 THEN OUTNESS := "9OR8";
					IF B = 9 THEN OUTNESS := "9OR9";
				END
			END ;			
	OUTPUT OUTNESS;
END
