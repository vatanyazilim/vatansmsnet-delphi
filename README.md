
  

# VatanSMS.Net Delphi SDK

  

VatanSMS API'sini Delphi projelerinizde kolayca kullanmak için geliştirilmiş bir SDK.

  

## Kurulum

  

### Manuel Kurulum:

1.  **`VatanSmsClient.pas`** dosyasını projenize ekleyin.

2. Delphi IDE'sinde projenizin `uses` kısmına `VatanSmsClient` birimini dahil edin.

  

---

  

## Kullanım

  

Aşağıda, Delphi ile **VatanSMS.Net Delphi SDK** kullanılarak API isteklerinin nasıl yapıldığını gösteren örnekler yer almaktadır:

  

---

  

### **1. 1-to-N SMS Gönderimi**

**Açıklama:**

Birden fazla numaraya aynı mesajı göndermek için kullanılır.

  

**Parametreler:**

-  `Phones`: Mesaj gönderilecek telefon numaralarının listesi. (`TArray<string>`)

-  `Message`: Gönderilecek mesaj içeriği. (`string`)

-  `Sender`: Gönderici adı (örneğin, "FIRMA"). (`string`)

-  `MessageType`: Mesaj türü, varsayılan olarak "normal". (`string`)

-  `MessageContentType`: Mesaj içerik türü, örneğin "bilgi" veya "ticari". (`string`)

-  `SendTime`: Mesajın gönderileceği tarih ve saat. Varsayılan olarak hemen gönderilir. (`TDateTime`)

  

**Örnek:**

```delphi
uses
  VatanSmsClient, System.SysUtils;

var
  SmsClient: TVatanSmsClient;
  Response: string;
begin
  SmsClient := TVatanSmsClient.Create('API_ID', 'API_KEY');
  try
    Response := SmsClient.SendSms(['5xxxxxxxxx', '5xxxxxxxxx'], 'Bu bir test mesajıdır.', 'SMSBASLIGINIZ');
    Writeln(Response);
  finally
    SmsClient.Free;
  end;
end.
```

  

---

  

### **2. N-to-N SMS Gönderimi**

**Açıklama:**

Her telefon numarasına farklı mesajlar göndermek için kullanılır.

  

**Parametreler:**

-  `Phones`: Telefon numaralarını ve mesajlarını içeren JSON nesnesi listesi. (`TArray<TJSONObject>`)

-  `Sender`: Gönderici adı. (`string`)

-  `MessageType`: Mesaj türü, varsayılan olarak "turkce". (`string`)

-  `MessageContentType`: Mesaj içerik türü. (`string`)

-  `SendTime`: Mesajın gönderileceği tarih ve saat. Varsayılan olarak hemen gönderilir. (`TDateTime`)

  

**Örnek:**

```delphi
uses
  VatanSmsClient, System.JSON, System.SysUtils;

var
  SmsClient: TVatanSmsClient;
  Phones: TArray<TJSONObject>;
  Phone1, Phone2: TJSONObject;
  Response: string;
begin
  SmsClient := TVatanSmsClient.Create('API_ID', 'API_KEY');
  try
    Phone1 := TJSONObject.Create;
    Phone1.AddPair('phone', '5xxxxxxxxx');
    Phone1.AddPair('message', 'Mesaj 1');

    Phone2 := TJSONObject.Create;
    Phone2.AddPair('phone', '5xxxxxxxxx');
    Phone2.AddPair('message', 'Mesaj 2');

    Phones := TArray<TJSONObject>.Create(Phone1, Phone2);

    Response := SmsClient.SendNtoNSms(Phones, 'SMSBASLIGINIZ');
    Writeln(Response);
  finally
    SmsClient.Free;
  end;
end.
```

  

---

  

### **3. Gönderici Adlarını Sorgulama**

**Açıklama:**

Hesabınıza tanımlı gönderici adlarını sorgulamak için kullanılır.

  

**Parametreler:**

- Hiçbir parametre almaz.

  

**Örnek:**

```delphi
uses
  VatanSmsClient, System.SysUtils;

var
  SmsClient: TVatanSmsClient;
  Response: string;
begin
  SmsClient := TVatanSmsClient.Create('API_ID', 'API_KEY');
  try
    Response := SmsClient.GetSenderNames;
    Writeln(Response);
  finally
    SmsClient.Free;
  end;
end.

```

  

---

  

### **4. Kullanıcı Bilgilerini Sorgulama**

**Açıklama:**

Hesap bilgilerinizi sorgulamak için kullanılır.

  

**Parametreler:**

- Hiçbir parametre almaz.

  

**Örnek:**

```delphi
uses
  VatanSmsClient, System.SysUtils;

var
  SmsClient: TVatanSmsClient;
  Response: string;
begin
  SmsClient := TVatanSmsClient.Create('API_ID', 'API_KEY');
  try
    Response := SmsClient.GetUserInformation;
    Writeln(Response);
  finally
    SmsClient.Free;
  end;
end.
```

  

---

  

### **5. Rapor Detayı Sorgulama**

**Açıklama:**

Belirli bir raporun detaylarını sorgulamak için kullanılır.

  

**Parametreler:**

-  `ReportId`: Sorgulanacak raporun ID'si. (`Integer`)

-  `Page`: Sayfa numarası, varsayılan olarak 1. (`Integer`)

-  `PageSize`: Bir sayfada gösterilecek rapor sayısı, varsayılan olarak 20. (`Integer`)

  

**Örnek:**

```delphi
uses
  VatanSmsClient, System.SysUtils;

var
  SmsClient: TVatanSmsClient;
  Response: string;
begin
  SmsClient := TVatanSmsClient.Create('API_ID', 'API_KEY');
  try
    Response := SmsClient.GetReportDetail(123456);
    Writeln(Response);
  finally
    SmsClient.Free;
  end;
end.
```

  

---

  

### **6. Tarih Bazlı Rapor Sorgulama**

**Açıklama:**

Belirli bir tarih aralığındaki raporları sorgulamak için kullanılır.

  

**Parametreler:**

-  `StartDate`: Başlangıç tarihi. (`string`)

-  `EndDate`: Bitiş tarihi. (`string`)

  

**Örnek:**

```delphi
uses
  VatanSmsClient, System.SysUtils;

var
  SmsClient: TVatanSmsClient;
  Response: string;
begin
  SmsClient := TVatanSmsClient.Create('API_ID', 'API_KEY');
  try
    Response := SmsClient.GetReportsByDate('2023-01-01', '2023-12-31');
    Writeln(Response);
  finally
    SmsClient.Free;
  end;
end.
```

  

---

  

### **7. Sonuç Sorgusu**

**Açıklama:**

Gönderilen bir raporun durumunu sorgulamak için kullanılır.

  

**Parametreler:**

-  `ReportId`: Sorgulanacak raporun ID'si. (`Integer`)

  

**Örnek:**

```delphi
uses
  VatanSmsClient, System.SysUtils;

var
  SmsClient: TVatanSmsClient;
  Response: string;
begin
  SmsClient := TVatanSmsClient.Create('API_ID', 'API_KEY');
  try
    Response := SmsClient.GetReportStatus(123456);
    Writeln(Response);
  finally
    SmsClient.Free;
  end;
end.
```

  

---

  

### **8. İleri Tarihli SMS İptali**

**Açıklama:**

Zamanlanmış bir SMS gönderimini iptal etmek için kullanılır.

  

**Parametreler:**

-  `Id`: İptal edilecek SMS'in ID'si. (`Integer`)

  

**Örnek:**

```delphi
uses
  VatanSmsClient, System.SysUtils;

var
  SmsClient: TVatanSmsClient;
  Response: string;
begin
  SmsClient := TVatanSmsClient.Create('API_ID', 'API_KEY');
  try
    Response := SmsClient.CancelFutureSms(123);
    Writeln(Response);
  finally
    SmsClient.Free;
  end;
end.
```

  

## Lisans

Bu SDK, MIT lisansı ile lisanslanmıştır. Daha fazla bilgi için `LICENSE` dosyasına göz atabilirsiniz.