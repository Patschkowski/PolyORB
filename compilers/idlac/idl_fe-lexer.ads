------------------------------------------------------------------------------
--                                                                          --
--                           POLYORB COMPONENTS                             --
--                                                                          --
--                         I D L _ F E . L E X E R                          --
--                                                                          --
--                                 S p e c                                  --
--                                                                          --
--            Copyright (C) 2001 Free Software Foundation, Inc.             --
--                                                                          --
-- PolyORB is free software; you  can  redistribute  it and/or modify it    --
-- under terms of the  GNU General Public License as published by the  Free --
-- Software Foundation;  either version 2,  or (at your option)  any  later --
-- version. PolyORB is distributed  in the hope that it will be  useful,    --
-- but WITHOUT ANY WARRANTY;  without even the implied warranty of MERCHAN- --
-- TABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public --
-- License  for more details.  You should have received  a copy of the GNU  --
-- General Public License distributed with PolyORB; see file COPYING. If    --
-- not, write to the Free Software Foundation, 59 Temple Place - Suite 330, --
-- Boston, MA 02111-1307, USA.                                              --
--                                                                          --
-- As a special exception,  if other files  instantiate  generics from this --
-- unit, or you link  this unit with other files  to produce an executable, --
-- this  unit  does not  by itself cause  the resulting  executable  to  be --
-- covered  by the  GNU  General  Public  License.  This exception does not --
-- however invalidate  any other reasons why  the executable file  might be --
-- covered by the  GNU Public License.                                      --
--                                                                          --
--                PolyORB is maintained by ACT Europe.                      --
--                    (email: sales@act-europe.fr)                          --
--                                                                          --
------------------------------------------------------------------------------

--  $Id: //droopi/main/compilers/idlac/idl_fe-lexer.ads#2 $

with Errors;

package Idl_Fe.Lexer is

   pragma Elaborate_Body;

   -----------------------------
   -- IDL keywords and tokens --
   -----------------------------

   --  All the idl_keywords
   --
   --  IDL Syntax and semantics, CORBA V2.3 � 3.2.4
   --
   --  All the idl tokens.
   type Idl_Token is
      (
       T_Error,           --  Position 0.
       T_Abstract,        --  Keywords, synchronised with keywords
       T_Any,
       T_Attribute,
       T_Boolean,
       T_Case,
       T_Char,
       T_Const,
       T_Context,
       T_Custom,
       T_Default,
       T_Double,
       T_Enum,
       T_Exception,
       T_Factory,
       T_False,
       T_Fixed,
       T_Float,
       T_In,
       T_Inout,
       T_Interface,
       T_Long,
       T_Module,
       T_Native,
       T_Object,
       T_Octet,
       T_Oneway,
       T_Out,
       T_Private,
       T_Public,
       T_Raises,
       T_Readonly,
       T_Sequence,
       T_Short,
       T_String,
       T_Struct,
       T_Supports,
       T_Switch,
       T_True,
       T_Truncatable,
       T_Typedef,
       T_Unsigned,
       T_Union,
       T_ValueBase,
       T_ValueType,
       T_Void,
       T_Wchar,
       T_Wstring,
       T_Semi_Colon,          -- ;  --  graphical character tokens
       T_Left_Cbracket,       -- {
       T_Right_Cbracket,      -- }
       T_Colon,               -- :
       T_Comma,               -- ,
       T_Colon_Colon,         -- ::
       T_Left_Paren,          -- (
       T_Right_Paren,         -- )
       T_Equal,               -- =
       T_Bar,                 -- |
       T_Circumflex,          -- ^
       T_Ampersand,           -- &
       T_Greater_Greater,     -- >>
       T_Less_Less,           -- <<
       T_Plus,                -- +
       T_Minus,               -- -
       T_Star,                -- *
       T_Slash,               -- /
       T_Percent,             -- %
       T_Tilde,               -- ~
       T_Less,                -- <
       T_Greater,             -- >
       T_Left_Sbracket,       -- [
       T_Right_Sbracket,      -- ]
       T_Lit_Decimal_Integer,        --  Literals
       T_Lit_Octal_Integer,
       T_Lit_Hexa_Integer,
       T_Lit_Char,
       T_Lit_Wide_Char,
       T_Lit_Simple_Floating_Point,
       T_Lit_Exponent_Floating_Point,
       T_Lit_Pure_Exponent_Floating_Point,
       T_Lit_String,
       T_Lit_Wide_String,
       T_Lit_Simple_Fixed_Point,
       T_Lit_Floating_Fixed_Point,
       T_Identifier,                 --  Identifier
       T_Eof,                        --  Misc
       T_End_Pragma,
       T_Pragma,
       T_Line
       );


   ----------------------------------------------------
   --  The main methods : initialize and next_token  --
   ----------------------------------------------------

   procedure Initialize
     (Filename : in String;
      Preprocess : in Boolean;
      Keep_Temporary_Files : in Boolean);
   --  Initializes the lexer by opening the file to process
   --  and by preprocessing it if necessary

   procedure Preprocess_File (Filename : in String);
   --  Preprocess a file and output the result on standard out.

   procedure Remove_Temporary_Files;
   --  Remove temporary files.

   function Get_Next_Token return Idl_Token;
   --  Analyse forward and return the next token.
   --  Returns T_Error if the entry is invalid.

   ------------------------------------------
   -- Current state of the lexer.          --
   -- These subprograms must not be called --
   -- outside the parser.                  --
   ------------------------------------------

   package Lexer_State is

      function Get_Lexer_Location return Errors.Location;
      --  Return the location of the current token.

      function Get_Lexer_String return String;
      --  If the current token is an identifier, a literal
      --  or a pragma, return its string value

   end Lexer_State;

   -----------------------------
   --  idl string processing  --
   -----------------------------

   --  compares two idl identifiers. The result is either DIFFER, if they
   --  are different identifiers, or CASE_DIFFER if it is the same identifier
   --  but with a different case on some letters, or at last EQUAL if it is
   --  the same word.
   --
   --  CORVA V2.3, 3.2.3
   --  When comparing two identifiers to see if they collide :
   --    - Upper- and lower-case letters are treated as the same letter. (...)
   --    - all characters are significant
   type Ident_Equality is (Differ, Case_Differ, Equal);
   function Idl_Identifier_Equal (Left, Right : String)
                                  return Ident_Equality;




   -----------------------------------------------------
   --  Tools and constants for the preprocessor call  --
   -----------------------------------------------------

   --  Adds an argument to be given to the preprocessor
   procedure Add_Argument (Str : String);




private

   -----------------------------------
   --  low level string processing  --
   -----------------------------------

   --  sets the location of the current token
   --  actually only sets the line and column number
   procedure Set_Token_Location;

   --  returns the real location in the parsed file. The word real
   --  means that the column number was changed to take the
   --  tabulations into account
   function Get_Real_Location return Errors.Location;

   --  Reads the next line
   procedure Read_Line;

   --  skips current char
   procedure Skip_Char;

   --  skips the current line
   procedure Skip_Line;

   --  Gets the next char and consume it
   function Next_Char return Character;

   --  returns the next char without consuming it
   --  warning : if it is the end of a line, returns
   --  LF and not the first char of the next line
   function View_Next_Char return Character;

   --  returns the next next char without consuming it
   --  warning : if it is the end of a line, returns
   --  LF and not the first or second char of the next line
   function View_Next_Next_Char return Character;

   --  returns the current char
   function Get_Current_Char return Character;

   --  calculates the new offset of the column when a tabulation
   --  occurs.
   procedure Refresh_Offset;

   --  Skips all spaces.
   --  Actually, only used in scan_preprocessor
   procedure Skip_Spaces;

   --  Skips a /* ... */ comment
   procedure Skip_Comment;

   --  Sets a mark in the text.
   --  If the line changes, the mark is replaced at the beginning
   --  of the new line
   procedure Set_Mark;

   --  Sets the mark on the char following the current one.
   procedure Set_Mark_On_Next_Char;

   --  Sets another mark in the text.
   --  If the line changes, the mark is replaced at the beginning
   --  of the new line
   procedure Set_End_Mark;

   --  Sets the second mark on the char before the current one.
   procedure Set_End_Mark_On_Previous_Char;

   --  gets the text from the mark to the current position
   function Get_Marked_Text return String;

   --  skips the characters until the next ' or the end of the line
   procedure Go_To_End_Of_Char;

   --  skips the characters until the next " or the end of the file
   procedure Go_To_End_Of_String;


   ---------------------------------
   --  low level char processing  --
   ---------------------------------

   --  returns true if C is an idl alphabetic character
   function Is_Alphabetic_Character (C : Standard.Character) return Boolean;

   --  returns true if C is a digit
   function Is_Digit_Character (C : Standard.Character) return Boolean;

   --  returns true if C is an octal digit
   function Is_Octal_Digit_Character (C : Standard.Character) return Boolean;

   --  returns true if C is an hexadecimal digit
   function Is_Hexa_Digit_Character (C : Standard.Character) return Boolean;

   --  returns true if C is an idl identifier character, ie either an
   --  alphabetic character or a digit or the character '_'
   function Is_Identifier_Character (C : Standard.Character) return Boolean;


   -----------------------------
   --  idl string processing  --
   -----------------------------

   --  the three kinds of identifiers : keywords, true
   --  identifiers or miscased keywords.
   type Idl_Keyword_State is
     (Is_Keyword, Is_Identifier, Bad_Case);

   --  checks whether s is an Idl keyword or not
   --  the result can be Is_Keyword if it is,
   --  Is_Identifier if it is not and Bad_Case if
   --  it is one but with bad case
   --  Is_escaped says if the identifier was preceeded
   --  by an underscore or not
   --
   --  IDL Syntax and semantics, CORBA V2.3 � 3.2.4
   --
   --  keywords must be written exactly as in the above list. Identifiers
   --  that collide with keywords (...) are illegal.
   procedure Is_Idl_Keyword (S : in String;
                             Is_Escaped : in Boolean;
                             Is_A_Keyword : out Idl_Keyword_State;
                             Tok : out Idl_Token);


   ----------------------------------------
   --  scanners for chars, identifiers,  --
   --    numeric, string literals and    --
   --      preprocessor directives.      --
   ----------------------------------------

   --  Called when the current character is a '.
   --  This procedure sets Current_Token and returns.
   --  The get_marked_text function returns then the
   --  character
   --
   --  IDL Syntax and semantics, CORBA V2.3 � 3.2.5
   --
   --  Char Literals : (3.2.5.2)
   --  A character literal is one or more characters enclosed in single
   --  quotes, as in 'x'.
   --  Nongraphic characters must be represented using escape sequences as
   --  defined in Table 3-9. (escape sequences are \n, \t, \v, \b, \r, \f,
   --  \a, \\, \?, \', \", \ooo, \xhh and \uhhhh)
   --
   --  The escape \ooo consists of the backslash followed by one, two or
   --  three octal digits that are taken to specify the value of the desired
   --  character. The escape \xhh consists of the backslash followed by x
   --  followed by one or two hexadecimal digits that are taken to specify
   --  the value of the desired character.
   --
   --  The escape \uhhhh consist of a backslash followed by the character
   --  'u', followed by one, two, three or four hexadecimal digits.
   --
   --  Wide is used to say if the scanner should scan a wide
   --  character or not. If not and the character looks like
   --  '/u...' then an error is raised and the function returns
   --  T_Error
   function Scan_Char (Wide : Boolean) return Idl_Token;


   --  Called when the current character is a ".
   --  This procedure sets Current_Token and returns.
   --  The get_marked_text function returns then the
   --  string literal
   --
   --  IDL Syntax and semantics, CORBA V2.3 � 3.2.5
   --
   --  String Literals : (3.2.5.1)
   --  A string literal is a sequence of characters (...) surrounded
   --  by double quotes, as in "...".
   --
   --  Adjacent string literals are concatenated.
   --  (...)
   --  Within a string, the double quote character " must be preceded
   --  by a \.
   --  A string literal may not contain the character '\0'.
   --
   --  Wide is used to say if the scanner should scan a wide
   --  string or not. If not and a character looks like
   --  '/u...' then an error is raised
   function Scan_String (Wide : Boolean) return Idl_Token;


   --  Called when the current character is a letter.
   --  This procedure sets TOKEN and returns.
   --  The get_marked_text function returns then the
   --  name of the identifier
   --  The is_escaped parameter says if this identifier was
   --  preceeded by an underscore or not
   --
   --  IDL Syntax and semantics, CORBA V2.3, 3.2.5
   --
   --  Wide Chars : 3.5.2.2
   --  Wide characters litterals have an L prefix, for example :
   --      const wchar C1 = L'X';
   --
   --  Wide Strings : 3.5.2.4
   --  Wide string literals have an L prefix, for example :
   --      const wstring S1 = L"Hello";
   --
   --  Identifiers : 3.2.3
   --  An identifier is an arbritrarily long sequence of ASCII
   --  alphabetic, digit and underscore characters.  The first
   --  character must be an ASCII alphabetic character. All
   --  characters are significant.
   --
   --  Keywords : 3.2.4
   --  keywords must be written exactly as in the above list. Identifiers
   --  that collide with keywords (...) are illegal. For example,
   --  "boolean" is a valid keyword, "Boolean" and "BOOLEAN" are
   --  illegal identifiers.
   function Scan_Identifier (Is_Escaped : Boolean) return Idl_Token;


   --  Called when the current character is a digit.
   --  This procedure sets Current_Token and returns.
   --  The get_marked_text function returns then the
   --  numeric literal
   --
   --  IDL Syntax and semantics, CORBA V2.3 � 3.2.5
   --
   --  Integers Literals : (3.2.5.1)
   --  An integer literal consisting of a sequence of digits is taken to be
   --  decimal (base ten), unless it begins with 0 (digit zero).  A sequence
   --  of digits starting with 0 is taken to be an octal integer (base eight).
   --  The digits 8 and 9 are not octal digits.  A sequence of digits preceded
   --  by 0x or 0X is taken to be a hexadecimal integer (base sixteen).  The
   --  hexadecimal digits include a or A through f or F with decimal values
   --  ten to through fifteen, repectively. For example, the number twelve can
   --  be written 12, 014 or 0XC
   --
   --  Floating-point literals : (3.2.5.3)
   --  A floating-point literal consists of an integer part, a decimal point,
   --  a fraction part, an e or E, and an optionnaly signed integer exponent.
   --  The integer and fraction parts both consists of a sequence of decimal
   --  (base ten) digits. Either the integer part or the fraction part (but not
   --  both may be missing; either the decimal point or the letter e (or E) and
   --  the exponent (but not both) may be missing.
   --
   --  Fixed-point literals : (3.2.5.5)
   --  A fixed-point decimal literal consists of an integer part, a decimal
   --  point, a fraction part and a d or D. The integer and fraction part both
   --  consist of a sequence of decimal (base ten) digits. Either the integer
   --  part or the fraction part (but not both) may be missing; the decimal
   --  point (but not the letter d (or D)) may be missing
   function Scan_Numeric return Idl_Token;


   --  Called when the current character is a _.
   --  This procedure sets Current_Token and returns.
   --  The get_marked_text function returns then the
   --  identifier
   --
   --  IDL Syntax and semantics, CORBA V2.3 � 3.2.3.1
   --
   --  "users may lexically "escape" identifiers by prepending an
   --  underscore (_) to an identifier.
   function Scan_Underscore return Idl_Token;


   --  Called when the current character is a #.
   --  Deals with the preprocessor directives.
   --  Actually, most of these are processed by gcc in a former
   --  step; this function only deals with #PRAGMA and
   --  #LINE directives.
   --  it returns true if it produced a token, false else
   --
   --  IDL Syntax and semantics, CORBA V2.3 � 3.3
   function Scan_Preprocessor return Boolean;



   -------------------------
   --  Maybe useless ???  --
   -------------------------

--    subtype Idl_Keywords is Idl_Token range T_Any .. T_Wstring;

--    function Idl_Compare (Left, Right : String) return Boolean;


--    --  Return the idl_token TOK as a string.
--    --  Format is "`keyword'", "`+'" (for symbols), "identifier `id'"
--    function Image (Tok : Idl_Token) return String;


end Idl_Fe.Lexer;

