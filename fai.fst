BEGIN
	INTEGER FEED;

	INTEGER A;
	INTEGER B;

	A := -1;
	B := -1;	

	DENOTED OUTNESS;

	INPUT FEED;
	IF FEED < 1 THEN FEED := 0; 
	FEED := FEED % 9;
	IF FEED < 1 THEN FEED := 9;
		IF A = -1 THEN A := FEED;
		IF A != -1 THEN IF B = -1 THEN B := FEED;
		IF A > -1 THEN IF B > -1 THEN 
			BEGIN
				IF A = 0 THEN IF B = 0 THEN OUTNESS := "0?0";
				IF A = 1 THEN IF B = 1 THEN OUTNESS := "1?1";
				IF A = 2 THEN IF B = 2 THEN OUTNESS := "2?2";
				IF A = 3 THEN IF B = 3 THEN OUTNESS := "3?3";
				IF A = 4 THEN IF B = 4 THEN OUTNESS := "4?4";
				IF A = 5 THEN IF B = 5 THEN OUTNESS := "5?5";
				IF A = 6 THEN IF B = 6 THEN OUTNESS := "6?6";
				IF A = 7 THEN IF B = 7 THEN OUTNESS := "7?7";
				IF A = 8 THEN IF B = 8 THEN OUTNESS := "8?8";
				IF A = 9 THEN IF B = 9 THEN OUTNESS := "9?9";		

				IF A = 1 THEN IF B = 0 THEN OUTNESS := "1?0";		
				IF A = 1 THEN IF B = 2 THEN OUTNESS := "1?2";		
				IF A = 1 THEN IF B = 3 THEN OUTNESS := "1?3";		
				IF A = 1 THEN IF B = 4 THEN OUTNESS := "1?4";		
				IF A = 1 THEN IF B = 5 THEN OUTNESS := "1?5";		
				IF A = 1 THEN IF B = 6 THEN OUTNESS := "1?6";		
				IF A = 1 THEN IF B = 7 THEN OUTNESS := "1?7";		
				IF A = 1 THEN IF B = 8 THEN OUTNESS := "1?8";		
				IF A = 1 THEN IF B = 9 THEN OUTNESS := "1?9";

				IF A = 2 THEN IF B = 0 THEN OUTNESS := "2?0";
				IF A = 2 THEN IF B = 1 THEN OUTNESS := "2?1";
				IF A = 2 THEN IF B = 3 THEN OUTNESS := "2?3";
				IF A = 2 THEN IF B = 4 THEN OUTNESS := "2?4";				
				IF A = 2 THEN IF B = 5 THEN OUTNESS := "2?5";
				IF A = 2 THEN IF B = 6 THEN OUTNESS := "2?6";
				IF A = 2 THEN IF B = 7 THEN OUTNESS := "2?7";
				IF A = 2 THEN IF B = 8 THEN OUTNESS := "2?8";
				IF A = 2 THEN IF B = 9 THEN OUTNESS := "2?9";
			END ;			
	OUTPUT OUTNESS;
END