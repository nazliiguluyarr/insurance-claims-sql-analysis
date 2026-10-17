# Insurance Claims Analytics – SQL Portfolio Project

## [ENG] English

### About the Project

This project analyses insurance claims data using SQL. It covers data quality checks, exploratory analysis and business-focused analysis.

The project uses three tables:

- `claims`
- `agents`
- `vendors`

The main dataset contains **10,000 claim records**. The analysis was completed using PostgreSQL and pgAdmin.

### Dataset Source

The dataset used in this project was obtained from Kaggle:

Insurance Claims Fraud Data  
https://www.kaggle.com/datasets/mastmustu/insurance-claims-fraud-data

The analysis uses the related claims, agent and vendor data provided in the dataset.

### Objective

The goal was not only to write SQL queries, but also to use the data to answer practical business questions.

The project follows this flow:

1. Validate table sizes
2. Check duplicate records
3. Check NULL / missing values
4. Validate relationships between tables
5. Perform exploratory data analysis
6. Answer business questions with deeper analysis

### SQL Used

Main SQL concepts used in the project:

- `SELECT`, `WHERE`, `GROUP BY`, `HAVING`, `ORDER BY`
- `INNER JOIN` and `LEFT JOIN`
- `CASE WHEN`
- CTEs (`WITH`)
- Window functions
- `PERCENTILE_CONT`
- `CORR`
- `DATE_TRUNC`
- Date difference calculations
- `COUNT`, `SUM`, `AVG`, `MIN`, `MAX`
- NULL checks
- `CROSS JOIN`

### File Structure

```text
SQL/
├── 01_data_validation.sql
├── 02_duplicate_data_check.sql
├── 03_null_check.sql
├── 04_referential_integrity_check.sql
├── 05_exploratory_data_analysis.sql
└── 06_business_analysis.sql
```

**01_data_validation.sql**  
Checks the number of records in each table.

**02_duplicate_data_check.sql**  
Checks duplicate agent IDs, vendor IDs and claim transaction IDs.

**03_null_check.sql**  
Checks missing values in important fields used in the analysis.

**04_referential_integrity_check.sql**  
Checks whether agent and vendor IDs in the claims table match records in the related tables.

**05_exploratory_data_analysis.sql**  
Includes portfolio summary, insurance type analysis, claim status, incident severity and monthly trends.

**06_business_analysis.sql**  
Focuses on vendor involvement, agent/vendor-level analysis, reporting delay and high-value claim risk concentration.

### Key Findings

- The dataset contains **10,000 claims** with a total claim amount of **165,638,300**.
- The average claim amount is **16,563.83**.
- Claim frequency is relatively balanced across insurance types, but claim amounts are not.
- **Life** represents about **16.82%** of claim volume but approximately **55.23%** of total claim value.
- **3,245 claims** have no vendor ID. These records were retained because vendor involvement may not be required for every claim.
- Average and median claim amounts are similar between vendor-involved and no-vendor claims.
- At agent level, the correlation between claim count and total claim amount is approximately **+0.585**, while the correlation between claim count and average claim amount is close to **0**.
- Vendor-level analysis shows a similar pattern: approximately **+0.603** correlation between claim count and total claim amount, and almost no relationship between claim count and average claim amount.
- Average reporting delay is **3.21 days**, with a median of **3 days** and a range of **0–5 days**.
- High-value claims were defined using the **95th percentile** instead of an arbitrary monetary threshold. The resulting threshold is **72,000**.
- **498 claims (4.98%)** were classified as high-value, and all of them belong to **Life** insurance.
- High-value claims are spread across **421 different agents**. The highest number for a single agent is only **4**.
- High-value risk is therefore strongly concentrated by insurance type, but not by agent or vendor.

### Business Recommendations

- Life claims should receive closer monitoring because they represent a disproportionately high share of total claim value.
- High-value claim monitoring should focus primarily on insurance type rather than individual agents or vendors, since no strong concentration was observed at agent or vendor level.
- Reporting-delay patterns should be investigated further, especially the 5-day concentration observed in some segments.
  
### Data Quality and Limitations

- NULL values in `vendor_id` were not automatically treated as data errors.
- The `claim_status` field contains `A` and `D`. Since no data dictionary is available, these codes were not interpreted as “Approved”, “Denied” or any other business meaning.
- May 2020 and June 2021 are incomplete months, so this was considered when interpreting monthly trends.
- Correlation results describe relationships in the data and should not be interpreted as proof of causation.

### How to Run

The SQL files can be executed in PostgreSQL in the following order:

```text
01 → 02 → 03 → 04 → 05 → 06
```

---

## [TR] Türkçe

### Proje Hakkında

Bu proje, sigorta hasar verileri üzerinde SQL kullanarak veri kalitesi kontrolü, keşifsel analiz ve iş analizi yapmak amacıyla hazırlandı.

Projede üç tablo kullanıldı:

- `claims`
- `agents`
- `vendors`

Ana veri setinde **10.000 hasar kaydı** bulunuyor. Analizler PostgreSQL ve pgAdmin kullanılarak yapıldı.

### Veri Seti Kaynağı

Bu projede kullanılan veri seti Kaggle üzerinden alınmıştır:

Insurance Claims Fraud Data  
https://www.kaggle.com/datasets/mastmustu/insurance-claims-fraud-data

Analizde veri setinde yer alan claim, agent ve vendor verileri kullanılmıştır.

### Amaç

Projenin amacı sadece sorgu yazmak değil, veriden iş açısından anlamlı sonuçlar çıkarmaktı. Bu nedenle analiz şu sırayla ilerledi:

1. Veri büyüklüğünü kontrol etme
2. Duplicate kayıt kontrolü
3. NULL / eksik veri kontrolü
4. Tablolar arası referans kontrolü
5. Keşifsel veri analizi
6. İş sorularına yönelik detaylı analiz

### Kullanılan SQL Konuları

Projede kullandığım başlıca SQL yapıları:

- `SELECT`, `WHERE`, `GROUP BY`, `HAVING`, `ORDER BY`
- `INNER JOIN` ve `LEFT JOIN`
- `CASE WHEN`
- CTE (`WITH`)
- Window functions
- `PERCENTILE_CONT`
- `CORR`
- `DATE_TRUNC`
- Tarih farkı hesaplama
- `COUNT`, `SUM`, `AVG`, `MIN`, `MAX`
- NULL kontrolleri
- `CROSS JOIN`

### Dosya Yapısı

```text
SQL/
├── 01_data_validation.sql
├── 02_duplicate_data_check.sql
├── 03_null_check.sql
├── 04_referential_integrity_check.sql
├── 05_exploratory_data_analysis.sql
└── 06_business_analysis.sql
```

**01_data_validation.sql**  
Tablolardaki kayıt sayılarını kontrol eder.

**02_duplicate_data_check.sql**  
Agent, vendor ve claim transaction ID alanlarında mükerrer kayıtları kontrol eder.

**03_null_check.sql**  
Analizde kullanılan önemli alanlardaki eksik değerleri kontrol eder.

**04_referential_integrity_check.sql**  
Claims tablosundaki agent ve vendor ID'lerinin ilgili tablolarda karşılığı olup olmadığını kontrol eder.

**05_exploratory_data_analysis.sql**  
Genel portföy görünümü, sigorta türleri, claim status, incident severity ve aylık trend analizlerini içerir.

**06_business_analysis.sql**  
Vendor involvement, agent/vendor bazlı analizler, reporting delay ve high-value claim risk yoğunlaşması gibi iş sorularına odaklanır.

### Öne Çıkan Bulgular

- Toplam **10.000 claim** ve **165.638.300** toplam claim amount bulunuyor.
- Ortalama claim amount **16.563,83**.
- Claim sayıları sigorta türleri arasında oldukça dengeli dağılırken, claim tutarları aynı şekilde dağılmıyor.
- **Life**, claim sayısının yaklaşık **%16,82**'sini oluşturmasına rağmen toplam claim tutarının yaklaşık **%55,23**'ünü oluşturuyor.
- **3.245 claim** için vendor bilgisi bulunmuyor. Bu kayıtlar silinmedi; vendor involvement gerektirmeyen claimler olabileceği için analizde korundu.
- Vendor bulunan ve bulunmayan claimlerin ortalama ve medyan tutarları birbirine yakın.
- Agent bazında claim sayısı ile toplam claim tutarı arasında yaklaşık **+0,585** korelasyon bulunurken, claim sayısı ile ortalama claim tutarı arasındaki ilişki yaklaşık **0**.
- Vendor bazında da benzer bir sonuç var: claim sayısı ile toplam tutar arasında yaklaşık **+0,603**, claim sayısı ile ortalama claim tutarı arasında ise yaklaşık **0** korelasyon bulunuyor.
- Ortalama reporting delay **3,21 gün**, medyan **3 gün** ve gözlenen aralık **0–5 gün**.
- High-value claim sınırı, keyfi bir tutar seçmek yerine **95. yüzdelik** kullanılarak belirlendi. Eşik **72.000** olarak hesaplandı.
- **498 claim (%4,98)** high-value olarak sınıflandırıldı ve bu claimlerin tamamı **Life** sigorta türünde yer aldı.
- High-value claimler **421 farklı agent** arasında dağılmış durumda. Tek bir agentta görülen en yüksek sayı yalnızca **4**.
- Bu nedenle high-value risk sigorta türü açısından Life'ta yoğunlaşırken, agent veya vendor bazında belirgin bir yoğunlaşma göstermiyor.

### İş Önerileri

- Toplam claim tutarındaki yüksek payı nedeniyle Life sigorta türü daha yakından izlenebilir.
- High-value claim takibinde agent veya vendor yerine öncelikle sigorta türüne odaklanmak daha anlamlı görünmektedir; çünkü agent ve vendor bazında belirgin bir yoğunlaşma görülmemiştir.
- Bazı segmentlerde görülen 5 günlük reporting delay yoğunlaşması daha detaylı incelenebilir.

### Veri Kalitesi ve Sınırlamalar

- `vendor_id` alanındaki NULL değerler doğrudan veri hatası olarak kabul edilmedi.
- `claim_status` alanında `A` ve `D` kodları bulunuyor. Veri sözlüğü olmadığı için bu kodlara “Approved”, “Denied” gibi anlamlar verilmedi.
- Mayıs 2020 ve Haziran 2021 tam ay olmadığı için aylık trend yorumlarında bu durum dikkate alındı.
- Analiz sonuçları ilişki ve dağılımları gösterir; korelasyon sonuçları nedensellik olarak yorumlanmamalıdır.

### Çalıştırma

SQL dosyaları PostgreSQL üzerinde sırayla çalıştırılabilir:

```text
01 → 02 → 03 → 04 → 05 → 06
```
