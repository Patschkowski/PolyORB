
from test_utils import *
import sys

if not client_server(r'corba/all_exceptions/client', r'giop_1_1.conf',
                     r'corba/all_exceptions/server', r'giop_1_1.conf'):
    fail()

