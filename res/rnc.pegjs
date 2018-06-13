/*
topLevel	  =  	decl* (pattern / grammarContent*)
decl	  =  	"namespace" identifierOrKeyword "=" namespaceURILiteral
/ "default" "namespace" [identifierOrKeyword] "=" namespaceURILiteral
/ "datatypes" identifierOrKeyword "=" literal
pattern	  =  	"element" nameClass "{" pattern "}"
/ "attribute" nameClass "{" pattern "}"
/ pattern ("," pattern)+
/ pattern ("&" pattern)+
/ pattern ("/" pattern)+
/ pattern "?"
/ pattern "*"
/ pattern "+"
/ "list" "{" pattern "}"
/ "mixed" "{" pattern "}"
/ identifier
/ "parent" identifier
/ "empty"
/ "text"
/ [datatypeName] datatypeValue
/ datatypeName ["{" param* "}"] [exceptPattern]
/ "notAllowed"
/ "external" anyURILiteral [inherit]
/ "grammar" "{" grammarContent* "}"
/ "(" pattern ")"
param	  =  	identifierOrKeyword "=" literal
exceptPattern	  =  	"-" pattern
grammarContent	  =  	start
/ define
/ "div" "{" grammarContent* "}"
/ "include" anyURILiteral [inherit] ["{" includeContent* "}"]
includeContent	  =  	define
/ start
/ "div" "{" includeContent* "}"
start	  =  	"start" assignMethod pattern
define	  =  	identifier assignMethod pattern
assignMethod	  =  	"="
/ "/="
/ "&="
nameClass	  =  	name
/ nsName [exceptNameClass]
/ anyName [exceptNameClass]
/ nameClass "/" nameClass
/ "(" nameClass ")"
name	  =  	identifierOrKeyword
/ CName
exceptNameClass	  =  	"-" nameClass
datatypeName	  =  	CName
/ "string"
/ "token"
datatypeValue	  =  	literal
anyURILiteral	  =  	literal
namespaceURILiteral	  =  	literal
/ "inherit"
inherit	  =  	"inherit" "=" identifierOrKeyword
identifierOrKeyword	  =  	identifier
/ keyword
identifier	  =  	(NCName - keyword)
/ quotedIdentifier
quotedIdentifier	  =  	"\" NCName
*/

start
  = literalSegment

CName
  = NCName ":" NCName

nsName
  = NCName ":*"

anyName
  = "*"

literal
  = literalSegment ("~" literalSegment)+

literalSegment
  = '"""' ('"'? '"'? (CharLiteralWithNewLine / "'"))* '"""' { return text(); }
  / "'''" ("'"? "'"? (CharLiteralWithNewLine / '"'))* "'''" { return text(); }
  / '"' (CharLiteralBase / "'")* '"' { return text(); }
  / "'" (CharLiteralBase / '"')* "'" { return text(); }

CharLiteralBase
  = [\\t\x20\x21\x23-\x26\x28-\uD7FF\uE000-\uFFFD]

CharLiteralWithNewLine
  = CharLiteralBase / [\\n\\r]

keyword
  = "attribute"
  / "default"
  / "datatypes"
  / "div"
  / "element"
  / "empty"
  / "external"
  / "grammar"
  / "include"
  / "inherit"
  / "list"
  / "mixed"
  / "namespace"
  / "notAllowed"
  / "parent"
  / "start"
  / "string"
  / "text"
  / "token"

// XML NCName
NCName
  = NameStartChar (NameChar)* { return text(); }

NameStartChar
  = c: [A-Z_a-z\xC0-\xD6\xD8-\xF6] { return c; }
  / c: [\xF8-\u02FF\u0370-\u037D\u037F-\u1FFF] { return c; }
  / c: [\u200C-\u200D\u2070-\u218F\u2C00-\u2FEF] { return c; }
  / c: [\u3001-\uD7FF\uF900-\uFDCF\uFDF0-\uFFFD] { return c; }

NameChar
  = c: NameStartChar { return c; }
  / c: [-\\.0-9\xB7\u0300-\u036F\u203F-\u2040] { return c; }
