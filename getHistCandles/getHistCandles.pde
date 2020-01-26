final String api_key = "48db3546e09e037c829ce0507b4da944-0e75d408b9e2bb35a1e98a3409506871";
final String accID = "101-001-12970645-001";
final String currencyPair = "GBP_JPY";                           //currency pair
final String granularity = "M1";                                 //granularity
final String candleType = "BA";                                  // choose bid ask based candle or both or mid-based
final String dataDirectory = "./";
final String startTime = "2019-12-12T20%3A00%3A00.000000000Z";   //yyyy-mm-ddThh%3Amm%3Ass.sssssssssZ
final int num_candles = 5000; // max = 5000
String histFileName = dataDirectory + "hist.json";
StringList std = new StringList(); 
StringList err = new StringList();
String rqst = "curl -H \"Authorization: Bearer " + api_key + "\" \"" + "https://api-fxpractice.oanda.com/v3/accounts/" + accID + "/instruments/" +
currencyPair + "/candles?granularity=" + granularity + "&count=" + num_candles + "&price=" + candleType + "&from=" + startTime //options
+ "\"";
shell(std, err, rqst + " > " + histFileName);

JSONObject wholeData = loadJSONObject(histFileName);
JSONArray candleDatas = wholeData.getJSONArray("candles");
int dataSize = candleDatas.size();
String[] Aopens  = new String[dataSize];
String[] Ahighs  = new String[dataSize];
String[] Alows   = new String[dataSize];
String[] Acloses = new String[dataSize];

String[] Bopens  = new String[dataSize];
String[] Bhighs  = new String[dataSize];
String[] Blows   = new String[dataSize];
String[] Bcloses = new String[dataSize];

String[] times = new String[dataSize];
for(int i = 0; i < dataSize; i++){
  JSONObject candleData = candleDatas.getJSONObject(i);
  
  times[i] = candleData.getString("time");
  times[i] = times[i].substring(0, 10) + " " + times[i].substring(11, 19);
  JSONObject bidData = candleData.getJSONObject("bid");
  JSONObject askData = candleData.getJSONObject("ask");
  
  Aopens[i]  = askData.getString("o");
  Ahighs[i]  = askData.getString("h");
  Alows[i]   = askData.getString("l");
  Acloses[i] = askData.getString("c");
  
  Bopens[i]  = bidData.getString("o");
  Bhighs[i]  = bidData.getString("h");
  Blows[i]   = bidData.getString("l");
  Bcloses[i] = bidData.getString("c"); 
}

saveStrings(dataDirectory + "askOpens.txt", Aopens);
saveStrings(dataDirectory + "askHighs.txt", Ahighs);
saveStrings(dataDirectory + "askLows.txt", Alows);
saveStrings(dataDirectory + "askCloses.txt", Acloses);

saveStrings(dataDirectory + "bidOpens.txt", Bopens);
saveStrings(dataDirectory + "bidHighs.txt", Bhighs);
saveStrings(dataDirectory + "bidLows.txt", Blows);
saveStrings(dataDirectory + "bidClose.txt", Bcloses);

saveStrings(dataDirectory + "times.txt", times);
println("data saved");
