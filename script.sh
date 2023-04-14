#!/bin/sh
rm -rf op
mkdir op

grep "REALIZED_PNL" csv.csv | cut -d, -f3,5 > op/pnl.csv
grep "COMMISSION" csv.csv | cut -d, -f3,5 > op/commision.csv
grep "INSURANCE_CLEAR" csv.csv | cut -d, -f3,5 > op/liq.csv
grep "FUNDING_FEE" csv.csv | cut -d, -f3,5 > op/fun.csv

#sort op/pnl.csv > op/sorted-numeric-pnl.csv
sort -t$',' -k2 op/pnl.csv > op/sorted-pnl.csv

#sort op/commision.csv > op/sorted-numeric-commision.csv
sort -t$',' -k2 op/commision.csv > op/sorted-commision.csv

#sort op/liq.csv > op/sorted-numeric-liq.csv
sort -t$',' -k2 op/commision.csv > op/sorted-liq.csv

#sort op/fun.csv > op/sorted-numeric-fun.csv
sort -t$',' -k2 op/fun.csv > op/sorted-fun.csv

grep "-" op/sorted-pnl.csv | sort -t$',' -k2 > op/loss.csv
grep -v "-" op/sorted-pnl.csv | sort -t$',' -k2 > op/profit.csv


grep "-" op/sorted-commision.csv  > op/negative-commision.csv
grep -v "-" op/sorted-commision.csv > op/positive-commision.csv

grep "-" op/sorted-fun.csv  > op/negative-fun.csv
grep -v "-" op/sorted-fun.csv > op/positive-fun.csv

echo "-----------------------------------------------------------------"
echo "TOP 10 LOSS :"
echo "-----------------------------------------------------------------"
cut -f1,2 -d"," op/pnl.csv | sort -n | head -10

echo "-----------------------------------------------------------------"
echo "TOP 10 PROFIT :"
echo "-----------------------------------------------------------------"
cut -f1,2 -d"," op/pnl.csv | sort -nr | head -10

echo "-----------------------------------------------------------------"
echo "TOP 10 LOSS DUE TO LIQUIDATION :"
echo "-----------------------------------------------------------------"
cut -f1,2 -d"," op/liq.csv | sort -n | head -10

echo "-----------------------------------------------------------------"
echo "TOP 5 NEGTATIVE COMMISION :"
echo "-----------------------------------------------------------------"
cut -f1,2 -d"," op/commision.csv | sort -n | head -5

echo "-----------------------------------------------------------------"
echo "TOP 5 POSITIVE COMMISION :"
echo "-----------------------------------------------------------------"
cut -f1,2 -d"," op/commision.csv | sort -nr | head -5

echo "-----------------------------------------------------------------"
echo "TOP 5 NEGTATIVE FUNDING FEES :"
echo "-----------------------------------------------------------------"
cut -f1,2 -d"," op/fun.csv | sort -n | head -5

echo "-----------------------------------------------------------------"
echo "TOP 5 POSITIVE FUNDING FEES :"
echo "-----------------------------------------------------------------"
cut -f1,2 -d"," op/fun.csv | sort -nr | head -5

pr=$(awk 'BEGIN {FS=OFS=","} ; {sum+=$1} END {print sum}' op/profit.csv)
echo "-----------------------------------------------------------------"
echo "TOTAL PROFIT: $pr"
echo "-----------------------------------------------------------------"

los=$(awk 'BEGIN {FS=OFS=","} ; {sum+=$1} END {print sum}' op/loss.csv)
echo "-----------------------------------------------------------------"
echo "TOTAL LOSS: $los"
echo "-----------------------------------------------------------------"

liq=$(awk 'BEGIN {FS=OFS=","} ; {sum+=$1} END {print sum}' op/liq.csv)
echo "-----------------------------------------------------------------"
echo "TOTAL LIQUIDATION: $liq"
echo "-----------------------------------------------------------------"

fee=$(awk 'BEGIN {FS=OFS=","} ; {sum+=$1} END {print sum}' op/commision.csv)
echo "-----------------------------------------------------------------"
echo "TOTAL COMMISION: $fee"
echo "-----------------------------------------------------------------"

fun=$(awk 'BEGIN {FS=OFS=","} ; {sum+=$1} END {print sum}' op/fun.csv)
echo "-----------------------------------------------------------------"
echo "TOTAL FUNDING FEE: $fun"
echo "-----------------------------------------------------------------"

to_los=$(awk "BEGIN{ print $los + $fee + $liq + $fun}")

echo "-----------------------------------------------------------------"
echo "TOTAL LOSS INCLUDING FEES & LIQUIDATION & COMMISION: $to_los"
echo "-----------------------------------------------------------------"

echo "-----------------------------------------------------------------"
tot=$(awk "BEGIN{ print $pr + $los + $fee + $liq + $fun }")
echo "CAPITAL LOST: $tot"
echo "-----------------------------------------------------------------"
