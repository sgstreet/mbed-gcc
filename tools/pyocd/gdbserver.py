from pyOCD.gdbserver import GDBServer
from pyOCD.board import MbedBoard

import logging

logging.basicConfig(level=logging.INFO)
board = MbedBoard.chooseBoard()
gdb = GDBServer(board, 3333)
