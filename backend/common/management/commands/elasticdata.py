import os
import json
import fitz
import gc
import urllib.parse
import pandas as pd
from django.core.management.base import BaseCommand
from core.texts.literal import has_meaning
from core.texts.splittext import split_paragraph
from core.texts.vectorize import USE_vectorize


ELASTIC_DATA_DIR = os.path.abspath(os.path.join(os.getcwd(), "..", "_elastic"))
DOCS_DIR = os.path.join(ELASTIC_DATA_DIR, "docs")

GROWTH_POTENTIAL_DOCS_FOLDER = "成長可能性資料"
EXPLANATORY_DOCS_FOLDER = "株主総会説明資料"

MATERIAL_TYPE_MAP = {
    GROWTH_POTENTIAL_DOCS_FOLDER : "growth_potential",
    EXPLANATORY_DOCS_FOLDER : "explanatory",
}

class Command(BaseCommand):
    help = "Elastic data processing commands"

    def add_arguments(self, parser):
        parser.add_argument("command", nargs="?", type=str)
        parser.add_argument('args', nargs='*', type=str)

    def extract_data(self, command, args):
        if command == "extract_data":
            if len(args) < 2:
                return print("Arguments must contain input data directory and financial statements CSV file")

            input_dir, csv_file, *_ =  args
            data_dir = os.path.join(ELASTIC_DATA_DIR, "data", input_dir)
            csv_file = os.path.join(ELASTIC_DATA_DIR, "data", csv_file)

            os.makedirs(os.path.join(DOCS_DIR, "company"), exist_ok=True)
            os.makedirs(os.path.join(DOCS_DIR, "document"), exist_ok=True)

            if not os.path.exists(data_dir):
                return print("Input directory does not exist")

            if not os.path.exists(csv_file):
                return print("CSV file does not exist")

            df = pd.read_csv(csv_file)
            df.fillna("", inplace=True)
            columns = list(df.columns)

            count, _ = df.shape

            for idx, row in df.iterrows():
                row = dict(zip(columns, row))
                row_materials = []
                edinet_code = row["edinet_code"]
                print(f"Processing...: {edinet_code}:{ (idx / count * 100):.2f}%", end='\r', flush=True)
                if idx % 100 == 0:
                    print(f"Processing...: {edinet_code}:{ (idx / count * 100):.2f}%")
                company = {
                    "edinet_code": edinet_code,
                    "security_code": row["security_code"],
                    "company_name": row["company_name"],
                    "company_address": row["company_address"],
                    "industry": row["industry"],

                    "balance_sheet_url": row["balance_sheet_url"],
                    "consolidated_balance_sheet_url": row["consolidated_balance_sheet_url"],
                    "profit_loss_url": row["profit_loss"],
                    "consolidated_profit_loss_url": row["consolidated_profit_loss"],
                    "meeting_explanatory_materials_url": row["meeting_explanatory_materials"],
                    "growth_potential_materials_url": row["growth_potential_material"],
                }
                for folder_name, material_type in MATERIAL_TYPE_MAP.items():
                    folder_path = os.path.join(data_dir, edinet_code, folder_name)
                    if not os.path.exists(folder_path) or not os.path.isdir(folder_path):
                        continue
                    for file_name in os.listdir(folder_path):
                        file_path = os.path.join(folder_path, file_name)
                        if not os.path.isfile(file_path):
                            continue

                        paragraphs = []
                        sentences = []
                        with fitz.open(file_path) as doc:
                            for page in doc:
                                content = page.get_text()
                                sentences.extend(filter(has_meaning, map(str.strip, split_paragraph(content))))

                        # Group text into 500 characters max per group
                        groups = []
                        group = []
                        for sentence in sentences:
                            if sum(map(len, group)) + len(sentence) > 500:
                                groups.append(group)
                                group = []
                            else:
                                group.append(sentence)
                        
                        for group in groups:
                            paragraphs.append("".join(group))

                        base_url = ""
                        if material_type == "growth_potential":
                            base_url = company["growth_potential_materials_url"].replace("https://console.cloud.google.com/storage/browser/", "https://storage.cloud.google.com/")
                        elif material_type == "explanatory":
                            base_url = company["meeting_explanatory_materials_url"].replace("https://console.cloud.google.com/storage/browser/", "https://storage.cloud.google.com/")



                        material = {
                            "type": material_type,
                            "file_name": file_name,
                            "url" : os.path.join(base_url, urllib.parse.quote(file_name)),
                        }
                        row_materials.append(dict(((k, v) for k, v in material.items())))

                        material["company"] = dict(((k, v) for k, v in company.items()))

                        # Material content
                        material["content"] = paragraphs
                        material["content_vector"] = USE_vectorize(["".join(paragraphs)])[0]

                        with open(os.path.join(DOCS_DIR, "document", f"{edinet_code}_{file_name}.json"), "w", encoding="utf-8") as f:
                            json.dump(material, f, ensure_ascii=False, indent=2)
                    
                    if row_materials:
                        company["materials"] = row_materials
                        
                with open(os.path.join(DOCS_DIR, "company", f"{edinet_code}.json"), "w", encoding="utf-8") as f:
                    json.dump(company, f, ensure_ascii=False, indent=2)
                gc.collect()

    def handle(self, *args, command, **options):
        # print("command", command)
        # print("args", args)
        self.extract_data(command, args)

