#! usr/bin/perl

use TXTCOD;

&main; # aller à la boucle principale

sub main{ # boucle principale


	print "Do you want to encode (e), decode (d), choose your algorithm (a) or quit (q)? ";  # demande de choix
	chomp($rep = <STDIN>);
	
	LGOTO:  # label servant à aller dans la fonction correspondante
	
	$rep =~ tr/[A-Z]/[a-z]/;  # transformation en minuscules
	
	if($rep =~ /d/){
		&codage;  # aller à la fonction de codage
	}
	elsif($rep =~ /d/){
		&decodage;  # aller à la fonction de décodage
	}
	elsif($rep =~ /a/){
		&algorithmic;  # Changement d'algorithme
	}
	elsif($rep =~ /q/){
		exit;
	}
	else{
		print "Please retype your choice: "; # redemande le choix
		chomp($rep = <STDIN>);
		goto LGOTO;  # aller au label LGOTO
	}

	goto &main;
	
}

sub codage{

    $annee = (gmtime(time))[5] + 1900;
    if(!(-e "$annee.cod")){
        #le fichier .cod n'existe pas
		TXTCOD::createcod;
    }
    print "\n\n****Encoding****\n\n";   # Informe l'utilisateur de l'entrée dans le système de codage
    
    print STDOUT "\nType the source file's name (leave this blank if you want to type you text): \n\n";
    
  VFILECODLECT:
    chomp($fic_sou = <STDIN>);             # demande le nom de fichier de lecture
    
    if($fic_sou eq ""){  # le champ est vide
	print STDOUT "\n\nType your text (ctrl-D to continue)\n\n";
	@text2conv = <STDIN>;   # reception du texte
	$fic_sou = ".tmpsou.txt";
	open (FICSOU, ">$fic_sou");
	print FICSOU @text2conv;
	close FICSOU;
    } 
    else{  # le champ n'est pas vide
	unless(open(FICSOU, $fic_sou)) {
	    print "###Error (fichier de lecture): $!\nPlease type source file's name: ";goto VFILECODLECT;
	}
	close FICSOU;
    }  #  fin de "le champ est vide"
    
    print STDOUT "\nType the destination file's name (leave this blank if you want to type you text): \n\n";
    
  VFILECODDEST:
    chomp($fic_dest = <STDIN>);  # demande le nom du fichier de destination (écriture)
    
    unless($fic_dest eq ""){ # le champ n'est pas vide
	unless(open(FICDEST, ">$fic_dest")) {
	    print "###Error $!\nPlease type destination file's name: ";goto VFILECODDEST;
	}
	close FICDEST;
    } else {
	$fic_dest = ".tmpdest.txt";
    }
    
    TXTCOD::codage($fic_sou, $fic_dest, "", &getalgo);
    
    if ($fic_dest eq ".tmpdest.txt"){
	open (FICTMP, $fic_dest);
	foreach (<FICTMP>){
	    print STDOUT $_;
	}
	close FICTMP;
    }
    
    print STDOUT "\nOperation successful.\n\n\n\n";
    
    goto &main;
    
}  # fin codage

sub decodage{
    $annee = (gmtime(time))[5] + 1900;
    if(!(-e "$annee.cod")){
		print "\n\n****Error : there isn't .cod file !!!****\n\n";
		goto &main;
    }

    print "\n\n****Decoding****\n\n";  # Informe l'utilisateur de l'entrée dans le système de décodage
    
    print STDOUT "\nType the source file's name (leave this blank if you want to type you text): \n\n";
    
  VFILEDECLECT:
    chomp($fic_sou = <STDIN>);             # demande le nom de fichier de lecture
    
    if($fic_sou eq ""){  # le champ est vide
	print STDOUT "\n\nType your text (ctrl-D to continue)\n\n";
	@text2conv = <STDIN>;   # reception du texte
	$fic_sou = ".tmpsou.txt";
	open (FICSOU, ">$fic_sou");
	print FICSOU @text2conv;
	close FICSOU;
    } 
    else{  # le champ n'est pas vide
	unless(open(FICSOU, $fic_sou)) {
	    print "###Error: $!\nPlease type destination file's name: ";goto VFILEDECLECT;
	}
	close FICSOU;
    }  #  fin de "le champ est vide"
    
    print STDOUT "\nType the destination file's name (leave this blank if you want to type you text): \n\n";
    
  VFILEDECDEST:
    chomp($fic_dest = <STDIN>);  # demande le nom du fichier de destination (écriture)
    
    unless($fic_dest eq ""){ # le champ n'est pas vide
	unless(open(FICDEST, ">$fic_dest")) {
	    print "###Error $!\nPlease type destination file's name: ";goto VFILECODDEST;
	}
	close FICDEST;
    } else {
	$fic_dest = ".tmpdest.txt";
    }

    TXTCOD::decodage($fic_sou, $fic_dest, "", &getalgo);
    
    if ($fic_dest eq ".tmpdest.txt"){
	open (FICTMP, $fic_dest);
	foreach (<FICTMP>){
	    print STDOUT $_;
	}
	close FICTMP;
    }
    
    print "\nOperation successful.\n\n\n\n";  # message de fin
    
    goto &main;
}  # fin decodage

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
    print "\n\nUsed algorithm is $algo.\n" unless $algo eq "";
    print "\n\nUsed algorithm is default algorithm.\n" if $algo eq "";
    print "Please type .alc file to use (leave blank to put default algorithm)";
  DEFINEALGO:
    chomp($algotouse = <STDIN>);

    if(!open(TEST, $algotouse)){
	print "This algorithm doesn't exists. Please choose another one : ";
	goto DEFINEALGO;
    }
    close TEST;

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