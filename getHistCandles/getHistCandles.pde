final String api_key = "48db3546e09e037c829ce0507b4da944-0e75d408b9e2bb35a1e98a3409506871";
final String accID = "101-001-12970645-001";
final String currencyPair = "GBP_JPY";
final String granularity = "S5";
final String dataDirectory = "/home/scinfo23/230373g/sketchbook/";
String histFileName = dataDirectory + "hist.json";
StringList std = new StringList(); 
StringList err = new StringList();
final int num_candles = 12 * 60;
String rqst = "curl -H \"Authorization: Bearer " + api_key + "\" \"" + "https://api-fxpractice.oanda.com/v3/accounts/" + accID + "/instruments/" + currencyPair + "/candles?granularity=" + granularity + "&count=" + num_candles + "\"";
shell(std, err, rqst + " > " + histFileName);

JSONObject wholeData = loadJSONObject(histFileName);
JSONArray candleDatas = wholeData.getJSONArray("candles");
int dataSize = candleDatas.size();
float[] opens  = new float[dataSize];
float[] highs  = new float[dataSize];
float[] lows   = new float[dataSize];
float[] closes = new float[dataSize];
for(int i = 0; i < dataSize; i++){
  JSONObject candleData = candleDatas.getJSONObject(i);
  //opens[i]  = float(candleData.getString("o"));
  //highs[i]  = float(candleData.getString("h"));
  //lows[i]   = float(candleData.getString("l"));
  //closes[i] = float(candleData.getString("c"));  
  println(candleData);
}
