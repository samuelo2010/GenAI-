#program to analyze customer sentiment analysis and response provision
"""Sentiment Analysis and Response Provision in Jac"""
import from byllm.llm{Model}    
glob llm = Model(model_name = "gemini/gemini-2.0-flash");
def analyze_sentiment(text: str) -> str by llm(Method='Reason');
def generate_response(sentiment: str, text: str) -> str by llm();
with entry {
    customer_feedbacks = "I'm I grateful for the prompt service, but the product quality could be improved.";
    sentiment= analyze_sentiment(customer_feedbacks);
    response= generate_response(sentiment, customer_feedbacks);
    print(f"Customer Feedback: {response}");
    print(f"Response: {response} \n");}
    
    