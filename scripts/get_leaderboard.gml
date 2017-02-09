///get_leaderboard()
ini_open(working_directory + "leaderboard.ini");
for(var i = 0; i < 5; i++) {
    board[# i, 0] = ini_read_string(string(i), "name", "AAA");
    board[# i, 1] = ini_read_real(string(i), "points", 0);
}
ini_close();
