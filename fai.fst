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
					IF B = 0 THEN OUTNESS := "0?0";
					IF B = 1 THEN OUTNESS := "0?1";
					IF B = 2 THEN OUTNESS := "0?2";
					IF B = 3 THEN OUTNESS := "0?3";
					IF B = 4 THEN OUTNESS := "0?4";
					IF B = 5 THEN OUTNESS := "0?5";
					IF B = 6 THEN OUTNESS := "0?6";
					IF B = 7 THEN OUTNESS := "0?7";
					IF B = 8 THEN OUTNESS := "0?8";
					IF B = 9 THEN OUTNESS := "0?9";
				END
				IF A = 1 THEN
				BEGIN
					IF B = 0 THEN OUTNESS := "1?0";
					IF B = 1 THEN OUTNESS := "1?1";
					IF B = 2 THEN OUTNESS := "1?2";
					IF B = 3 THEN OUTNESS := "1?3";
					IF B = 4 THEN OUTNESS := "1?4";
					IF B = 5 THEN OUTNESS := "1?5";
					IF B = 6 THEN OUTNESS := "1?6";
					IF B = 7 THEN OUTNESS := "1?7";
					IF B = 8 THEN OUTNESS := "1?8";
					IF B = 9 THEN OUTNESS := "1?9";
				END
				IF A = 2 THEN
				BEGIN
					IF B = 0 THEN OUTNESS := "2?0";
					IF B = 1 THEN OUTNESS := "2?1";
					IF B = 2 THEN OUTNESS := "2?2";
					IF B = 3 THEN OUTNESS := "2?3";
					IF B = 4 THEN OUTNESS := "2?4";
					IF B = 5 THEN OUTNESS := "2?5";
					IF B = 6 THEN OUTNESS := "2?6";
					IF B = 7 THEN OUTNESS := "2?7";
					IF B = 8 THEN OUTNESS := "2?8";
					IF B = 9 THEN OUTNESS := "2?9";
				END
				IF A = 3 THEN
				BEGIN
					IF B = 0 THEN OUTNESS := "3?0";
					IF B = 1 THEN OUTNESS := "3?1";
					IF B = 2 THEN OUTNESS := "3?2";
					IF B = 3 THEN OUTNESS := "3?3";
					IF B = 4 THEN OUTNESS := "3?4";
					IF B = 5 THEN OUTNESS := "3?5";
					IF B = 6 THEN OUTNESS := "3?6";
					IF B = 7 THEN OUTNESS := "3?7";
					IF B = 8 THEN OUTNESS := "3?8";
					IF B = 9 THEN OUTNESS := "3?9";
				END
				IF A = 4 THEN
				BEGIN
					IF B = 0 THEN OUTNESS := "4?0";
					IF B = 1 THEN OUTNESS := "4?1";
					IF B = 2 THEN OUTNESS := "4?2";
					IF B = 3 THEN OUTNESS := "4?3";
					IF B = 4 THEN OUTNESS := "4?4";
					IF B = 5 THEN OUTNESS := "4?5";
					IF B = 6 THEN OUTNESS := "4?6";
					IF B = 7 THEN OUTNESS := "4?7";
					IF B = 8 THEN OUTNESS := "4?8";
					IF B = 9 THEN OUTNESS := "4?9";
				END
				IF A = 5 THEN
				BEGIN
					IF B = 0 THEN OUTNESS := "5?0";
					IF B = 1 THEN OUTNESS := "5?1";
					IF B = 2 THEN OUTNESS := "5?2";
					IF B = 3 THEN OUTNESS := "5?3";
					IF B = 4 THEN OUTNESS := "5?4";
					IF B = 5 THEN OUTNESS := "5?5";
					IF B = 6 THEN OUTNESS := "5?6";
					IF B = 7 THEN OUTNESS := "5?7";
					IF B = 8 THEN OUTNESS := "5?8";
					IF B = 9 THEN OUTNESS := "5?9";
				END
				IF A = 6 THEN
				BEGIN
					IF B = 0 THEN OUTNESS := "6?0";
					IF B = 1 THEN OUTNESS := "6?1";
					IF B = 2 THEN OUTNESS := "6?2";
					IF B = 3 THEN OUTNESS := "6?3";
					IF B = 4 THEN OUTNESS := "6?4";
					IF B = 5 THEN OUTNESS := "6?5";
					IF B = 6 THEN OUTNESS := "6?6";
					IF B = 7 THEN OUTNESS := "6?7";
					IF B = 8 THEN OUTNESS := "6?8";
					IF B = 9 THEN OUTNESS := "6?9";
				END
				IF A = 7 THEN
				BEGIN
					IF B = 0 THEN OUTNESS := "7?0";
					IF B = 1 THEN OUTNESS := "7?1";
					IF B = 2 THEN OUTNESS := "7?2";
					IF B = 3 THEN OUTNESS := "7?3";
					IF B = 4 THEN OUTNESS := "7?4";
					IF B = 5 THEN OUTNESS := "7?5";
					IF B = 6 THEN OUTNESS := "7?6";
					IF B = 7 THEN OUTNESS := "7?7";
					IF B = 8 THEN OUTNESS := "7?8";
					IF B = 9 THEN OUTNESS := "7?9";
				END
				IF A = 8 THEN
				BEGIN
					IF B = 0 THEN OUTNESS := "8?0";
					IF B = 1 THEN OUTNESS := "8?1";
					IF B = 2 THEN OUTNESS := "8?2";
					IF B = 3 THEN OUTNESS := "8?3";
					IF B = 4 THEN OUTNESS := "8?4";
					IF B = 5 THEN OUTNESS := "8?5";
					IF B = 6 THEN OUTNESS := "8?6";
					IF B = 7 THEN OUTNESS := "8?7";
					IF B = 8 THEN OUTNESS := "8?8";
					IF B = 9 THEN OUTNESS := "8?9";
				END
				IF A = 9 THEN
				BEGIN
					IF B = 0 THEN OUTNESS := "9?0";
					IF B = 1 THEN OUTNESS := "9?1";
					IF B = 2 THEN OUTNESS := "9?2";
					IF B = 3 THEN OUTNESS := "9?3";
					IF B = 4 THEN OUTNESS := "9?4";
					IF B = 5 THEN OUTNESS := "9?5";
					IF B = 6 THEN OUTNESS := "9?6";
					IF B = 7 THEN OUTNESS := "9?7";
					IF B = 8 THEN OUTNESS := "9?8";
					IF B = 9 THEN OUTNESS := "9?9";
				END
			END ;			
	OUTPUT OUTNESS;
END
