Create Database BankLoanDB;
USE BankLoanDB;

Select * from bank_loan_data;

DESCRIBE bank_loan_data;

-- DashBoard 1

/* Total Application */
Select count(id) as Total_Application from bank_loan_data;

-- updating the date to mySQL understandable format
UPDATE bank_loan_data
SET last_credit_pull_date = STR_TO_DATE(last_credit_pull_date, '%d-%m-%Y'),
    last_payment_date = STR_TO_DATE(last_payment_date, '%d-%m-%Y');

UPDATE bank_loan_data
SET next_payment_date = STR_TO_DATE(next_payment_date, '%d-%m-%Y');
    
/* converting the date in right format so that sql can understand */
/* Month on Month Sales */
SELECT COUNT(id) AS MTD_Total_Application
FROM bank_loan_data
WHERE MONTH(issue_date) = 12 
  AND YEAR(issue_date ) = 2021;

-- Total Loan amount given by the bank
SELECT SUM(loan_amount) AS TOTAL_FUNDED_AMOUNT
FROM bank_loan_data;

SET SQL_SAFE_UPDATES = 0;

-- Total Loan amount given by the bank - for a month
SELECT SUM(loan_amount) AS MTD_TOTAL_FUNDED_AMOUNT
FROM bank_loan_data
WHERE MONTH(issue_date) = 12
AND YEAR(issue_date) = 2021;

-- Total Loan amount given by the bank - for last month
SELECT SUM(loan_amount) AS PMTD_TOTAL_FUNDED_AMOUNT
FROM bank_loan_data
WHERE MONTH(issue_date) = 11
AND YEAR(issue_date) = 2021;

-- Total amount received from the bank
SELECT SUM(total_payment) AS Total_Amount_Received
FROM bank_loan_data;

-- Total Monthly amount received from the bank
SELECT SUM(total_payment) AS MTD_Total_Amount_Received
FROM bank_loan_data
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021;

-- Finding avergae interest rate
SELECT AVG(int_rate)*100 AS Interest_Rate 
FROM bank_loan_data;

-- Finding Debt to Income Ratio
SELECT ROUND(AVG(dti),4)*100 AS DTI
FROM bank_loan_data;

SELECT ROUND(AVG(dti),4)*100 AS DTI
FROM bank_loan_data
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021;

SELECT loan_status FROM bank_loan_data;

-- finding good loan percentage
SELECT
	(COUNT(CASE WHEN loan_status = 'Fully Paid' OR loan_status = 'Current' THEN id END))/ COUNT(id)  * 100 AS Good_Loan
    FROM bank_loan_data;

-- Good loan Applications
SELECT COUNT(id) as Good_Loan_Application FROM bank_loan_data
WHERE loan_status = 'Fully Paid' OR loan_status = 'Current';

-- Good loan funded amount by the bank
SELECT 
    SUM(loan_amount) AS Good_Loan_Funded
FROM
    bank_loan_data
WHERE
    loan_status = 'Fully Paid'
        OR loan_status = 'Current';

-- Good loan received by the bank
SELECT 
    SUM(total_payment) AS Good_Loan_Funded
FROM
    bank_loan_data
WHERE
    loan_status = 'Fully Paid'
        OR loan_status = 'Current';

-- finding bad loan percentage
SELECT
	(COUNT(CASE WHEN loan_status = 'Charged Off' THEN id END))/ COUNT(id)  * 100 AS Bad_Loan
    FROM bank_loan_data;
    
-- Bad loan Applications
SELECT COUNT(id) as Bad_Loan_Applications FROM bank_loan_data
WHERE loan_status = 'Charged Off';

-- Bad loan funded amount by the bank
SELECT 
    SUM(loan_amount) AS Bad_Loan_Funded
FROM
    bank_loan_data
WHERE
    loan_status = 'Charged Off';
    
-- Summary
SELECT 
    loan_status,
    COUNT(id) AS Total_Loan_Applications,
    SUM(total_payment) AS Total_Amount_Receieved,
    SUM(loan_amount) AS Total_Loan_Funded,
    AVG(int_rate) * 100 AS Interest_Rate,
    AVG(dti) * 100 AS DTI
FROM
    bank_loan_data
GROUP BY loan_status;


-- Dashboard 2
-- Bank Loan Report Monthly 
SELECT
    MONTH(issue_date) AS Month_Number,
    MONTHNAME(issue_date) AS MONTH_NAME,
    COUNT(id) AS Applications,
    SUM(loan_amount) AS Total_Funded_Amount,
    SUM(total_payment) AS Total_Received_Amount
FROM bank_loan_data
GROUP BY MONTH(issue_date), MONTHNAME(issue_date)
ORDER BY MONTH(issue_date);

-- Bank Loan Report Region-Wise
SELECT
    address_state,
    COUNT(id) AS Applications,
    SUM(loan_amount) AS Total_Funded_Amount,
    SUM(total_payment) AS Total_Received_Amount
FROM bank_loan_data
GROUP BY address_state
ORDER BY COUNT(id) DESC;

-- Bank Loan Report Term-wise
SELECT
    term AS Term,
    COUNT(id) AS Applications,
    SUM(loan_amount) AS Total_Funded_Amount,
    SUM(total_payment) AS Total_Received_Amount
FROM bank_loan_data
GROUP BY term
ORDER BY term;

-- Employee length analysis
SELECT
    emp_length As Length,
    COUNT(id) AS Applications,
    SUM(loan_amount) AS Total_Funded_Amount,
    SUM(total_payment) AS Total_Received_Amount
FROM bank_loan_data
GROUP BY emp_length
ORDER BY emp_length;

-- Loan Purpose Breakdown
SELECT 
    purpose AS Purpose,
    COUNT(id) AS Applications,
    SUM(loan_amount) AS Total_Funded_Amount,
    SUM(total_payment) AS Total_Received_Amount
FROM
    bank_loan_data
GROUP BY purpose
ORDER BY COUNT(id) DESC;

-- Home Ownership Analysis
SELECT 
    home_ownership,
    COUNT(id) AS Applications,
    SUM(loan_amount) AS Total_Funded_Amount,
    SUM(total_payment) AS Total_Received_Amount
FROM
    bank_loan_data
GROUP BY home_ownership
ORDER BY COUNT(id) DESC;

-- Home Ownership Analysis with filter
SELECT 
    home_ownership,
    COUNT(id) AS Applications,
    SUM(loan_amount) AS Total_Funded_Amount,
    SUM(total_payment) AS Total_Received_Amount
FROM
    bank_loan_data
WHERE grade = 'A'
GROUP BY home_ownership
ORDER BY COUNT(id) DESC;

