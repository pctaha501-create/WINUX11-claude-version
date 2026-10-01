#include "calculator_service.h"
#include <QRegularExpression>
#include <cmath>
class Parser{
 QString s;int p=0;bool ok=true;
 void ws(){while(p<s.size()&&s[p].isSpace())++p;}
 double number(){ws();int start=p;while(p<s.size()&&(s[p].isDigit()||s[p]=='.'))++p;if(start==p){ok=false;return 0;}return s.mid(start,p-start).toDouble();}
 double factor(){ws();if(p<s.size()&&s[p]=='('){++p;double v=expr();ws();if(p>=s.size()||s[p]!=')')ok=false;else ++p;return v;}bool neg=false;if(p<s.size()&&(s[p]=='+'||s[p]=='-')){neg=s[p]=='-';++p;}double v=number();return neg?-v:v;}
 double term(){double v=factor();while(ok){ws();if(p>=s.size()||(s[p]!='*'&&s[p]!='/'))break;QChar op=s[p++];double r=factor();if(op=='/'&&r==0){ok=false;return 0;}v=op=='*'?v*r:v/r;}return v;}
 double expr(){double v=term();while(ok){ws();if(p>=s.size()||(s[p]!='+'&&s[p]!='-'))break;QChar op=s[p++];double r=term();v=op=='+'?v+r:v-r;}return v;}
public:explicit Parser(const QString &x):s(x){}QString run(){double v=expr();ws();if(!ok||p!=s.size()||!std::isfinite(v))return "Error";return QString::number(v,'g',15);}
};
QString CalculatorService::evaluate(const QString &e)const{if(e.size()>256||!QRegularExpression("^[0-9+\\-*/().\\s]+$").match(e).hasMatch())return "Error";return Parser(e).run();}
