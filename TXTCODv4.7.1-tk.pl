#! usr/bin/perl

use Tk;
use TXTCOD;

if(Exists($ftxtcod)){
    $ftxtcod->raise();
}
else{

&init;

&main; # aller à la boucle principale

sub main{ # boucle principale

    
    $ftxtcod->Button(-text => "Encoding", -command => \&codage)->pack;
    $ftxtcod->Button(-text => "Decoding", -command => \&decodage)->pack;	
    $ftxtcod->Button(-text => "Choose an algorithm", -command => \&algorithmic)->pack;
    $ftxtcod->Button(-text => "Die", -command => sub{ $ftxtcod->destroy; })->pack;
    
    
}

sub codage{
    $annee = (gmtime(time))[5] + 1900;
    if(!(-e "$annee.cod")){
        #le fichier .cod n'existe pas
	TXTCOD::createcod;
    }

    $codwin = $ftxtcod->Toplevel();
    $codwin->title("Codage");
    
    $frame1 = $codwin->Frame()->pack;
    $frame2 = $codwin->Frame()->pack;
    $frame3 = $codwin->Frame()->pack;
    
    $fic_sou = "";
    $fic_dest = "";
    
    $frame1->Button(-text => "Choose source file",
		    -command => sub{ $fic_sou = $codwin->getOpenFile();}
		    )->pack(-side=>'left');
    $frame1->Button(-text => "Type the text in another window",
		    -command => sub{ $fic_sou = "";})->pack;
    
    $frame2->Button(-text => "Choose destination file",
		    -command => sub{ $fic_dest = $codwin->getSaveFile();}
		    )->pack(-side=>'left');
    $frame2->Button(-text => "Show result in another window",
		    -command => sub{ $fic_dest = "";})->pack;
    $frame3->Button(-text => "Continue",
		    -command => sub{ $continuecod++ })->pack;
    
    

    $ftxtcod->waitVariable(\$continuecod);
    
    
    
    
    if($fic_sou eq ""){  # le champ est vide
	$enterfen = $codwin->Dialog(
	                            -title => "Type your text",
				    -buttons => ["Continue"],
				    -default_button => "Continue",
				    );
	$txt = $enterfen->Scrolled("Text")->pack(-side=>'bottom',
	                                         -fill=>'both',
	                                         -expand=>1);
	$enterfen->Show();
	
	@text2conv = $txt->get("1.0", 'end');
	$fic_sou = ".tmpsou.txt";
	open (FICSOU, ">$fic_sou");
	print FICSOU @text2conv;
	close FICSOU;
    } 
    if($fic_dest eq ""){
	$fic_dest = ".tmpdest.txt";
    }
    TXTCOD::codage($fic_sou, $fic_dest, "", &getalgo);

    if($fic_dest eq ".tmpdest.txt"){
	$enterfen = $codwin->Dialog(
	                            -title => "There is the encoded text",
				    -buttons => ["OK"],
				    -default_button => "OK",
				    );
	$txt = $enterfen->Scrolled("Text")->pack(-side=>'bottom',
	                                         -fill=>'both',
	                                         -expand=>1);
	open (TEMP, ".tmpdest.txt");
	foreach(<TEMP>){
	    $txt->insert("end", $_);
	}
	close TEMP;
	$enterfen->Show();
    }

    &err("Operation successful");

    $codwin->destroy();

}  # fin codage

sub decodage{
    $annee = (gmtime(time))[5] + 1900;
    if(!(-e "$annee.cod")){
	err("Error : .cod file doesn't exists");
	return;
    }

    $codwin = $ftxtcod->Toplevel();
    $codwin->title("Decoding");
    
    $frame1 = $codwin->Frame()->pack;
    $frame2 = $codwin->Frame()->pack;
    $frame3 = $codwin->Frame()->pack;
    $frame4 = $codwin->Frame()->pack;
    
    $fic_sou = "";
    $fic_dest = "";
    
    $frame1->Button(-text => "Choose source file",
		    -command => sub{ $fic_sou = $codwin->getOpenFile(); })->pack(-side=>'left');
    $frame1->Button(-text => "Type the text in another window",
		    -command => sub{ $fic_sou = "";})->pack;
    
    $frame2->Button(-text => "Choose destination file",
		    -command => sub{ $fic_dest = $codwin->getSaveFile(); })->pack(-side=>'left');
    $frame2->Button(-text => "Show result in another window",
		    -command => sub{ $fic_dest = "";})->pack;
    $frame3->Label()->pack;
    
    $frame4->Button(-text => "Continue",
		    -command => sub{ $continuedec++ })->pack(-side=>'left');
    
    
    $ftxtcod->waitVariable(\$continuedec);
    
    if($fic_sou eq ""){  # le champ est vide
	$enterfen = $codwin->Dialog(
	                            -title => "Type your text",
				    -buttons => ["Continue"],
				    -default_button => "Continue",
				    );
	$txt = $enterfen->Scrolled("Text")->pack(-side=>'bottom',
	                                         -fill=>'both',
	                                         -expand=>1);
	$enterfen->Show();
	
	@text2conv = $txt->get("1.0", 'end');
	$fic_sou = ".tmpsou.txt";
	open (FICSOU, ">$fic_sou");
	print FICSOU @text2conv;
	close FICSOU;
    } 
    if($fic_dest eq ""){
	$fic_dest = ".tmpdest.txt";
    }
    TXTCOD::decodage($fic_sou, $fic_dest, "", &getalgo);
    if($fic_dest eq ".tmpdest.txt"){
	$enterfen = $codwin->Dialog(
				    -title => "There is the decoded text",
				    -buttons => ["OK"],
				    -default_button => "OK",
				    );
	$txt = $enterfen->Scrolled("Text")->pack(-side=>'bottom',
	                                         -fill=>'both',
	                                         -expand=>1);
	open (TEMP, ".tmpdest.txt");
	foreach(<TEMP>){
	    $txt->insert("end", $_);
	}
	close TEMP;
	$enterfen->Show();
    }

    &err("Operation successful");
    $codwin->destroy;
    
}  # fin decodage



sub init{
    if(Exists($mw)){
	$ftxtcod = $mw->Toplevel();
    } else {
	$ftxtcod = new MainWindow;
    }
    $ftxtcod->title("TXTCOD 4.7.1 version SAC 2.4 system");
    
    $err = $ftxtcod->Dialog(
			       -title => "Message",
			       -buttons => ["OK"],
			       -default_button => "OK",
			       -image => $fenwarbmp,
			       );
    $err->Label(-textvariable=>\$texterr)->pack;
    
    $tex = $ftxtcod->Dialog(
			       -title => "Help",
			       -buttons => ["OK"],
			       -default_button => "OK"
			       );
    $tex->geometry("900x550+0+0");
    
    $jp = $tex->Scrolled("Text")->place(-width=>900, -height=>500);
}

sub err{
    $texterr = shift;
    $err->Show();
}
sub tex{
    $texterr = shift;
    $jp->insert('end', $texterr);
    $jp->configure(state=>'disabled');
    $tex->Show();
    $jp->configure(state=>'normal');
    $jp->delete("1.0",'end');
}

sub algorithmic{
    open (PREFS, "TXTCOD4 prefs");
    foreach (<PREFS>){
	chomp($_);
	if ($_ =~ /^=algo/){
	    $_ =~ s/=algo//;
	    $algo = (split /\"/, $_)[1];
	}
	else{ push @saving, $_  }
    }
    close PREFS;
    $algowin = $ftxtcod->Dialog(
				   -title => "Algorithm",
				   -buttons => ["Valider"],
				   -default_button => "Valider",
				   );
    
    $textalgo = "Used algorithm is $algo";
    if ($algo eq ""){
	$textalgo = "Used algorithm is default algorithm";
    }
    
    $algowin->Label(-textvariable => \$textalgo)->pack;
    $algowin->Button(-text => "Choose algorithm file",
		     -command => sub{ $algotouse = $algowin->getOpenFile(); })->pack(-side=>'left');
    $algowin->Button(-text => "Use default algorithm",
		     -command => sub{ $algotouse = ""; })->pack(-side=>'left');
    
    
    $algowin->Show();
    
    open (PREFS, ">TXTCOD4 prefs");
    foreach (@saving){
	print PREFS $_;
	print PREFS "\n";
    }
    print PREFS "=algo\"$algotouse\"";
    close PREFS;
    
}
sub getalgo {
    open (PREFS, "TXTCOD4 prefs");
    foreach (<PREFS>){
	chomp($_);
	if ($_ =~ /^=algo/){
	    $_ =~ s/=algo//;
	    $algo = (split /\"/, $_)[1];
	}
    }
    close PREFS;
    return $algo;
}
MainLoop();
} #fin else
