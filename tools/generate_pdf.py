import sys
import os
import json
from datetime import datetime
from fpdf import FPDF

class PDF(FPDF):
    def header(self):
        self.set_font('helvetica', 'B', 15)
        self.cell(0, 10, 'Kernel Security Audit Report', new_x="LMARGIN", new_y="NEXT", align='C')
        self.ln(10)

    def footer(self):
        self.set_y(-15)
        self.set_font('helvetica', 'I', 8)
        self.cell(0, 10, f'Page {self.page_no()}', new_x="LMARGIN", new_y="NEXT", align='C')

def generate_report(kernel_version):
    pdf = PDF()
    pdf.add_page()
    
    # Title
    pdf.set_font('helvetica', 'B', 16)
    pdf.cell(0, 10, f'Target: {kernel_version}', new_x="LMARGIN", new_y="NEXT")
    pdf.set_font('helvetica', '', 12)
    pdf.cell(0, 10, f'Date: {datetime.now().strftime("%Y-%m-%d %H:%M:%S")}', new_x="LMARGIN", new_y="NEXT")
    pdf.ln(10)
    
    # Read Data
    warnings_file = f'race_warnings_{kernel_version}.txt'
    json_file = f'web_dashboard/data_{kernel_version}.json'
    
    total_warnings = 0
    top_vars = []
    
    if os.path.exists(json_file):
        with open(json_file, 'r', encoding='utf-8') as f:
            data = json.load(f)
            # The JSON structure has summary and race_warnings objects
            summary = data.get('summary', {})
            total_warnings = summary.get('total_warnings', 0)
            
            # Get top variables from race_warnings.top_variables
            race_warnings_data = data.get('race_warnings', {})
            top_vars = race_warnings_data.get('top_variables', [])
    elif os.path.exists(warnings_file):
        with open(warnings_file, 'r', encoding='utf-8') as f:
            lines = f.readlines()
            total_warnings = len([l for l in lines if "Data Race Warning" in l])
            
    # Summary Section
    pdf.set_font('helvetica', 'B', 14)
    pdf.cell(0, 10, '1. Executive Summary', new_x="LMARGIN", new_y="NEXT")
    pdf.set_font('helvetica', '', 12)
    
    # Use cell instead of multi_cell to avoid fpdf2 bugs with long text
    summary_text = f'This report provides a security audit summary for the {kernel_version} kernel.'
    pdf.cell(0, 10, summary_text, new_x="LMARGIN", new_y="NEXT")
    summary_text2 = f'The static analysis tool detected a total of {total_warnings} potential data race warnings.'
    pdf.cell(0, 10, summary_text2, new_x="LMARGIN", new_y="NEXT")
    pdf.ln(5)
    
    # Top Risky Variables
    pdf.set_font('helvetica', 'B', 14)
    pdf.cell(0, 10, '2. High-Risk Variables (Top 10)', new_x="LMARGIN", new_y="NEXT")
    pdf.set_font('helvetica', '', 12)
    
    if top_vars:
        # Table Header
        pdf.set_font('helvetica', 'B', 12)
        pdf.cell(100, 10, 'Variable Name', border=1)
        pdf.cell(40, 10, 'Warning Count', border=1, new_x="LMARGIN", new_y="NEXT")
        
        pdf.set_font('helvetica', '', 12)
        for var in top_vars:
            pdf.cell(100, 10, var['name'], border=1)
            pdf.cell(40, 10, str(var['count']), border=1, new_x="LMARGIN", new_y="NEXT")
    else:
        pdf.cell(0, 10, 'No variable statistics available. Please run the web dashboard generator first.', new_x="LMARGIN", new_y="NEXT")
        
    pdf.ln(10)
    
    # Detailed Warnings (Sample)
    pdf.set_font('helvetica', 'B', 14)
    pdf.cell(0, 10, '3. Recent Warnings Sample', new_x="LMARGIN", new_y="NEXT")
    pdf.set_font('helvetica', '', 8)
    
    if os.path.exists(warnings_file):
        with open(warnings_file, 'r', encoding='utf-8') as f:
            lines = f.readlines()
            # Just take the first 20 lines to avoid massive PDF
            sample_lines = lines[:20]
            for line in sample_lines:
                # Replace tabs and long spaces to avoid fpdf multi_cell issues
                clean_line = line.strip().replace('\t', '    ')
                if clean_line:
                    # Split long lines manually if needed, or just use cell
                    # Truncate to 90 chars to ensure it fits on the page
                    pdf.cell(0, 5, clean_line[:90] + ('...' if len(clean_line) > 90 else ''), new_x="LMARGIN", new_y="NEXT")
            if len(lines) > 20:
                pdf.ln(2)
                pdf.set_font('helvetica', 'I', 10)
                pdf.cell(0, 10, f'... and {len(lines)-20} more lines omitted.', new_x="LMARGIN", new_y="NEXT")
    else:
        pdf.cell(0, 10, 'No detailed warnings file found.', new_x="LMARGIN", new_y="NEXT")
        
    output_file = f'security_report_{kernel_version}.pdf'
    pdf.output(output_file)
    print(f"Successfully generated PDF report: {output_file}")

if __name__ == '__main__':
    kernel = sys.argv[1] if len(sys.argv) > 1 else 'linux-6.6.1'
    generate_report(kernel)
