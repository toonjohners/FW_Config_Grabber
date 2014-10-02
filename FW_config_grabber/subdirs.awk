BEGIN{exit_code=1}
{
  if (NF!=0)
   {
    if (NF>1)
     {
      if (substr($2,1,1)=="(")
       {
        cc=substr($2,2,length($2)-2);
        if (cc != 0)
         {
          print $1;
          exit_code = 0;
         }
       }
      else
       {
        print "\"" $0 "\"";
        exit_code = 0;
       }
     }
    else
     {
      print $1
      exit_code = 0;
     }
   }
}
END{exit exit_code}
