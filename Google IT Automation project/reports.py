#!/usr/bin/env python3

# A module to be used to generate a PDF report
from reportlab.lib.styles import getSampleStyleSheet
from reportlab.platypus import Paragraph, Spacer, Table, Image
from reportlab.platypus import SimpleDocTemplate

def generate_report(attachment, title, paragraph):
    styles = getSampleStyleSheet()
    report = SimpleDocTemplate(attachment)
    title_style = styles["h1"]
    title_style.alignment = 1
    report_title = Paragraph(title, title_style)
    report_table = Table(data=paragraph, style= None, hAlign = "LEFT")
    reports = report.build([report_title, report_table])
    return reports

