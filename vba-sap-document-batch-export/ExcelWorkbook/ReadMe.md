# Excel Workbook Template

This folder contains a sanitized example of the workbook structure expected by the VBA automation.

The workbook layout is representative of the original solution, but all business-specific information has been replaced with generic sample data.

To try the macro with sample data, use the `DocumentBatch.xlsm` file or prepare an Excel sheet with the following layout:

- **Row 2** is the first data row (row 1 optional for headers).  
- **Column A (A)** – `MaterialID` (for reference only; not used by the macro).  
- **Column B (B)** – `RawText` (cell content that may span multiple lines, e.g., several related IDs separated by line breaks; this is read by the macro from `MATERIAL_COL = "B"`).  
- **Column C (C)** – `Status` (`N` = process, `Y` = already done, `N/A` = skip).  
- **Column D (D)** – `DocumentID` (field that receives the document ID from SAP‑like logic; corresponds to `DOC_COL = "D"`).

For example:

| A (MaterialID) | B (RawText)                                 | C (Status) | D (DocumentID) |
|----------------|---------------------------------------------|-----------|----------------|
| MAT-0001       | MAT-0001<br>PCB-0001<br>Resistor-R1        | Y         | DOC-2026-0001  |
| MAT-0002       | MAT-0002<br>Resistor-R2<br>CAP-0002        | N/A       | DOC-2026-0002  |
| MAT-0003       | MAT-0003                                    | N         |                |

This structure lets the macro:

- Skip rows with `C = "N/A"` or `C = "Y"`.  
- For `C = "N"` and no existing PDF, attempt the full SAP‑to‑PDF workflow and update column `D` with the document ID.  
