unit VatanSmsClient;

(*
 * VatanSMS Delphi SDK
 * Developed by Timur (https://github.com/lyreq)
 * 
 * This SDK allows you to interact with the VatanSMS.Net API seamlessly.
 * For more details, visit https://vatansms.net
 * 
 * License: MIT
 *)

interface

uses
  System.SysUtils, System.Classes, System.Net.HttpClient, System.Net.URLClient, System.JSON;

type
  EVatanSmsException = class(Exception);

  TVatanSmsClient = class
  private
    FApiId: string;
    FApiKey: string;
    FBaseUrl: string;
    FHttpClient: THttpClient;
    function SendRequest(const Endpoint: string; const Payload: TJSONObject): string;
  public
    constructor Create(const AApiId, AApiKey: string; const ABaseUrl: string = 'https://api.toplusmspaketleri.com/api/v1');
    destructor Destroy; override;

    // SMS Gönderimi
    function SendSms(const Phones: TArray<string>; const Message, Sender: string;
      const MessageType: string = 'normal'; const MessageContentType: string = 'bilgi';
      const SendTime: TDateTime = 0): string;

    function SendNtoNSms(const Phones: TArray<TJSONObject>; const Sender: string;
      const MessageType: string = 'turkce'; const MessageContentType: string = 'bilgi';
      const SendTime: TDateTime = 0): string;

    // Bilgi Sorgulama
    function GetSenderNames: string;
    function GetUserInformation: string;

    // Raporlama
    function GetReportDetail(const ReportId: Integer; const Page: Integer = 1;
      const PageSize: Integer = 20): string;

    function GetReportsByDate(const StartDate, EndDate: string): string;

    function GetReportStatus(const ReportId: Integer): string;

    // İleri Tarihli SMS İptali
    function CancelFutureSms(const Id: Integer): string;
  end;

implementation

{ TVatanSmsClient }

constructor TVatanSmsClient.Create(const AApiId, AApiKey, ABaseUrl: string);
begin
  FApiId := AApiId;
  FApiKey := AApiKey;
  FBaseUrl := ABaseUrl.Trim(['/']);
  FHttpClient := THttpClient.Create;
end;

destructor TVatanSmsClient.Destroy;
begin
  FHttpClient.Free;
  inherited;
end;

function TVatanSmsClient.SendRequest(const Endpoint: string; const Payload: TJSONObject): string;
var
  RequestContent: TStringStream;
  Response: IHTTPResponse;
begin
  RequestContent := TStringStream.Create(Payload.ToString, TEncoding.UTF8);
  try
    Response := FHttpClient.Post(FBaseUrl + Endpoint, RequestContent, nil, [TNameValuePair.Create('Content-Type', 'application/json')]);
    if Response.StatusCode <> 200 then
      raise EVatanSmsException.CreateFmt('HTTP Error: %d - %s', [Response.StatusCode, Response.ContentAsString(TEncoding.UTF8)]);
    Result := Response.ContentAsString(TEncoding.UTF8);
  finally
    RequestContent.Free;
  end;
end;

function TVatanSmsClient.SendSms(const Phones: TArray<string>; const Message, Sender: string;
  const MessageType: string; const MessageContentType: string; const SendTime: TDateTime): string;
var
  Payload: TJSONObject;
  PhonesArray: TJSONArray;
  Phone: string;
begin
  Payload := TJSONObject.Create;
  try
    Payload.AddPair('api_id', FApiId);
    Payload.AddPair('api_key', FApiKey);
    Payload.AddPair('sender', Sender);
    Payload.AddPair('message_type', MessageType);
    Payload.AddPair('message', Message);
    Payload.AddPair('message_content_type', MessageContentType);

    PhonesArray := TJSONArray.Create;
    for Phone in Phones do
      PhonesArray.Add(Phone);
    Payload.AddPair('phones', PhonesArray);

    if SendTime > 0 then
      Payload.AddPair('send_time', DateTimeToStr(SendTime));

    Result := SendRequest('/1toN', Payload);
  finally
    Payload.Free;
  end;
end;

function TVatanSmsClient.SendNtoNSms(const Phones: TArray<TJSONObject>; const Sender, MessageType,
  MessageContentType: string; const SendTime: TDateTime): string;
var
  Payload: TJSONObject;
  PhonesArray: TJSONArray;
  Phone: TJSONObject;
begin
  Payload := TJSONObject.Create;
  try
    Payload.AddPair('api_id', FApiId);
    Payload.AddPair('api_key', FApiKey);
    Payload.AddPair('sender', Sender);
    Payload.AddPair('message_type', MessageType);
    Payload.AddPair('message_content_type', MessageContentType);

    PhonesArray := TJSONArray.Create;
    for Phone in Phones do
      PhonesArray.Add(Phone.Clone as TJSONObject);
    Payload.AddPair('phones', PhonesArray);

    if SendTime > 0 then
      Payload.AddPair('send_time', DateTimeToStr(SendTime));

    Result := SendRequest('/NtoN', Payload);
  finally
    Payload.Free;
  end;
end;

function TVatanSmsClient.GetSenderNames: string;
var
  Payload: TJSONObject;
begin
  Payload := TJSONObject.Create;
  try
    Payload.AddPair('api_id', FApiId);
    Payload.AddPair('api_key', FApiKey);
    Result := SendRequest('/senders', Payload);
  finally
    Payload.Free;
  end;
end;

function TVatanSmsClient.GetUserInformation: string;
var
  Payload: TJSONObject;
begin
  Payload := TJSONObject.Create;
  try
    Payload.AddPair('api_id', FApiId);
    Payload.AddPair('api_key', FApiKey);
    Result := SendRequest('/user/information', Payload);
  finally
    Payload.Free;
  end;
end;

function TVatanSmsClient.GetReportDetail(const ReportId, Page, PageSize: Integer): string;
var
  Payload: TJSONObject;
begin
  Payload := TJSONObject.Create;
  try
    Payload.AddPair('api_id', FApiId);
    Payload.AddPair('api_key', FApiKey);
    Payload.AddPair('report_id', TJSONNumber.Create(ReportId));
    Result := SendRequest(Format('/report/detail?page=%d&pageSize=%d', [Page, PageSize]), Payload);
  finally
    Payload.Free;
  end;
end;

function TVatanSmsClient.GetReportsByDate(const StartDate, EndDate: string): string;
var
  Payload: TJSONObject;
begin
  Payload := TJSONObject.Create;
  try
    Payload.AddPair('api_id', FApiId);
    Payload.AddPair('api_key', FApiKey);
    Payload.AddPair('start_date', StartDate);
    Payload.AddPair('end_date', EndDate);
    Result := SendRequest('/report/between', Payload);
  finally
    Payload.Free;
  end;
end;

function TVatanSmsClient.GetReportStatus(const ReportId: Integer): string;
var
  Payload: TJSONObject;
begin
  Payload := TJSONObject.Create;
  try
    Payload.AddPair('api_id', FApiId);
    Payload.AddPair('api_key', FApiKey);
    Payload.AddPair('report_id', TJSONNumber.Create(ReportId));
    Result := SendRequest('/report/single', Payload);
  finally
    Payload.Free;
  end;
end;

function TVatanSmsClient.CancelFutureSms(const Id: Integer): string;
var
  Payload: TJSONObject;
begin
  Payload := TJSONObject.Create;
  try
    Payload.AddPair('api_id', FApiId);
    Payload.AddPair('api_key', FApiKey);
    Payload.AddPair('id', TJSONNumber.Create(Id));
    Result := SendRequest('/cancel/future-sms', Payload);
  finally
    Payload.Free;
  end;
end;

end.
