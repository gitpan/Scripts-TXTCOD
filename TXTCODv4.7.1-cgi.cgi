#!/usr/bin/perl -w
use CGI qw/:standard/;
use CGI::Pretty qw( :html3 ); 
use TXTCOD;

if(!param('togo') && (param('codeco') eq "co" || param('codeco') eq "deco")){
	autoEscape(0);
	print header;
	print start_html("TXT2COD version 4.7 (web)");

    print "<center>";
    print start_multipart_form(
		     -method=>"POST",
		     -action => "TXTCODv4.7-cgi.gz");
    
    $codeco = "encode" if param('codeco') eq "co";
    $codeco = "decode .txt" if param('codeco') eq "deco";
    
    print table(
		TR(
		   td( "Select .cod file" ),
		   td( " : " ),
		   td( filefield(-name=>"codfile",
				 -size=>50,
				 -maxlength=>255)   
		       )
		   ),
		TR(
		   td( "Select the file you want to " . $codeco ),
		   td( " : " ),
		   td( filefield(-name=>"txtfile",
				 -size=>50,
				 -maxlength=>255)   
		       )
		   ),
		TR(
		   td( "Select .alc file optionnally" ),
		   td( " : " ),
		   td( filefield(-name=>"alcfile",
				 -size=>50,
				 -maxlength=>255)
		       )
		   ),
		);
    print "<br>";
    print hidden('togo','1');
    print hidden('codeco',param('codeco'));
    print submit(
		 -name=>'submit',
		 -value=>'Convertir');
    print end_form;
	print "<br><br><br>";
    print start_form(
		     -method=>"POST",
		     -action => "TXTCODv4.7-cgi.cgi");
	print submit(-name=>"submit",
				-value=>"Go back home");
	print end_form;
    print "</center>";
	print end_html;
} else {
	autoEscape(0); 
	print header;
	print start_html("TXT2COD version 4.7 (web)");
    print "<center><br>";
    print start_form(
		     -method=>"POST",
		     -action => "TXTCODv4.7-cgi.cgi");
	print hidden("codeco", "co");
	print submit(-name=>"submit",
				-value=>"Encode a file");
	print end_form;
	print "<br>";
    print start_form(
		     -method=>"POST",
		     -action => "TXTCODv4.7-cgi.cgi");
	print hidden("codeco", "deco");
	print submit(-name=>"submit",
				-value=>"Decode a file");
	print end_form;
	print "<br>";
    print start_form(
		     -method=>"POST",
		     -action => "TXTCODv4.7-cgi.gz");
	print hidden("createcod", "1");
	print submit(-name=>"submit",
				-value=>"Create a .cod file");
	print end_form;
	print "<br>";
	print end_html;
}



