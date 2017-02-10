///write_leaderboard()
ini_open(working_directory + "leaderboard.ini");
for(var i = 0; i < 5; i++) {
    ini_write_string(string(i), "name", string(board[# i, 0]));
    ini_write_string(string(i), "points", string(board[# i, 1]));
}
ini_close();
