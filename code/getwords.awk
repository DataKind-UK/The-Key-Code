#
# getwords.awk, 17 Jul 15

# Generate bigrams from organization names

# Remove let from end of word, if it is there 
function rm_end_let(word, let)
{
if (substr(word, length(word)) == let)
   word=substr(word, 1, length(word)-1)

return word
}


BEGIN {
        FS="\""
        org_num=0
        }

# "id","name","postcode","latitude","longitude"
# 2240,"Bolton Lads   Girls and Club Warrington Youth Club","BL1 4AG",53.577688,-2.437957


        {
        org=tolower($2) 
        org_num+=1
        #  Let's not remove duplicates, just append that information to the organization name
        if (org ~ /do not/)
           next
        # single letter sequences that mean something
        sub(" f c", " fc", org)
        sub(" r c ", " rc ", org)
        sub(" y i p", " yip", org)
        sub("county council", "county_council", org)
        num_w=split(org, words, " ")
        prev_str=""
        for (w=1; w <= num_w; w++)
           {
           nw=rm_end_let(words[w], "s")
           nw=rm_end_let(nw, "'")
           if (prev_str != "")
              {
              bi_str=prev_str "-" nw
              bi_cnt[bi_str]+=1
              bi_org[bi_str]=   bi_org[bi_str] "," substr($1, 1, length($1)-2)
              }
           prev_str=nw
           word_cnt[nw]+=1
        # Line number or organization id?
           # word_org[nw]=word_org[nw] "," org_num
           word_org[nw]=word_org[nw] "," substr($1, 1, length($1)-2)
           }
        # print org
        next
        }

END {
#       for (w in word_cnt)
#          print w " " word_cnt[w]
#       for (w in bi_cnt)
#          print w " " bi_cnt[w]
#       print "group_str,organisation_id"
#       for (w in word_org)
#          {
#          nc=split(word_org[w], org_id, ",")
#          if (nc > 5)
#             {
#             # print w word_org[w]
#       # First entry is empty
#             for (i=2; i <= nc; i++)
#                if (w != "")
#                   print w "," org_id[i]
#             }
#          }
        # A very simple approach to removing duplicates
        bi_len=0
        for (w1 in bi_org)
           bi_len+=1
        for (w1=1; w1<= bi_len; w1++)
           for (w2=w1+1; w2<= bi_len; w2++)
              if (bi_org[w1] == bi_org[w2])
                 bi_org[w2]=","

        print "bi_group_str,organisation_id"
        for (w in bi_org)
           {
           nc=split(bi_org[w], org_id, ",")
           if (nc > 5)
              {
              # print w bi_org[w]
        # First entry is empty
              for (i=2; i <= nc; i++)
                 if (w != "")
                    print w "," org_id[i]
              }
           }
        }
