# LM-BFF for FewCLUE

This repository implements [FewCLUE](https://github.com/CLUEbenchmark/FewCLUE) tasks with [LM-BFF]((https://arxiv.org/pdf/2012.15723.pdf)) (Making Pre-trained Language Models Better Few-shot Learners). Please read the following documents to know how to use this repository and add your own dataset.

本代码实现了 [LM-BFF]((https://arxiv.org/pdf/2012.15723.pdf)) 在 [FewCLUE](https://github.com/CLUEbenchmark/FewCLUE) 任务上训练、验证和预测。以下文档讲介绍如何运行本代码并添加自定义数据集。

## 实验结果

| 模型   | score     | eprstmt  | bustm  | ocnli   | csldcp   | tnews | wsc | ifytek| csl | chid  |
| :----:| :----:  | :----: |:----: |:----: |:----: |:----: |:----: |:----: |:----: |:----: |
| <a href="https://arxiv.org/abs/2004.05986">Human</a>        | 82.49 |90.0N  | 88.0N    |  90.3N  | 68.0N |71.0N | 98.0N | 66.0N |  84.0N|  87.1N|
| <a href="https://github.com/ymcui/Chinese-BERT-wwm">FineTuningB</a>        | 39.35 |61.9N   | 54.1N   | 33.6N  | 25.6N |40.5N | 50.3N |22.6N | 50.5N| 15.0N|
| <a href="https://github.com/google-research/bert">FineTuningR</a>        | | 63.2N |55.5N   | 33.5N    | 35.7N  | 49.3N |49.6N | 32.8N |50.0N | |
| <a href="https://arxiv.org/pdf/2009.07118.pdf">PET</a>      | 57.36 | 87.2N | 64.0  | 43.9N | 56.9N |53.7N  | 59.2N| 35.1N | 55.0N | 61.3N |
| <a href="https://arxiv.org/pdf/2009.07118.pdf">PtuningB</a>      | 51.81| 88.5N | 65.4  | 35.0N | 44.4N |  48.2N  | 51.0N | 32.0N| 50.0N | 57.6N |
| <a href="https://arxiv.org/pdf/2009.07118.pdf">PtuningGPT</a>      | 46.44| 75.65N  | 54.9N   | 35.75N  | 33.69N  |  45.3N   | 49.0N | 24.0N | 53.5N  | 13.7N  |
| <a href="https://arxiv.org/abs/2005.14165">Zero-shot-G</a>      | 43.36N |  57.54N |  50N  | 34.4N  |  26.23N |  36.96N | 50.31N | 19.04N | 50.14N  | 65.63N  |
| <a href="https://arxiv.org/abs/2005.14165">Zero-shot-R</a>      | 44.61N |  85.2N |   50.6N | 40.3N | 12.6N  |   25.3N  | 50.0N | 27.7N |  52.2N |  57.6N |
| <a href="https://arxiv.org/pdf/2012.15723.pdf">LM-BFF</a> |  | 84.59 | 54.06 | 43.10 |  53.64 |  56.27 | 51.84 | 46.14 | 51.16 | 61.3 |

注：

- 模板生成模型 `uer/t5-base-chinese-cluecorpussmall`, 分类模型 `hfl/chinese-roberta-wwm-ext`。
- 使用 `Auto-T`，即只自动生成模板，`beam=30`。
- `few_shot_type=prompt`，即 Prompt-based fine-tuning。预实验发现原文效果最好的 Prompt-based fine-tuning with demonstrations 效果并不佳。

## 运行步骤

1. 安装实验环境  
   运行本代码需要两个虚拟环境 `lm-bff` 以及 `lm-bff-gen`。若使用 `conda`，可按照以下命令安装环境，

   ```
   conda create -n lm-bff python=3.7
   pip install -r ./requirements.txt

   conda create -n lm-bff-gen --clone lm-bff
   pip install -U transformers
   ```

2. 准备数据
   
   ```shell
   # 切换到 FewCLUE 根目录
   cd ../../..
   python baselines/models_pytorch/LM-BFF/convert_format.py
   python baselines/models_pytorch/LM-BFF/tools/copy_fewclue_datasets.py
   ```

   该脚本将所有文件转换为没有 heading 的 csv 格式，保存在 `$ROOT_DIR/datasets/lm-bff` 下，接着将所有文件复制到 `./data/k-shot` 下准备使用。

3. 生成模板
   在 `generate_template.sh` 中将 `TASK` 变量设为你想使用的数据集。接着运行命令，

   ```
   conda activate lm-bff-gen
   bash generate_template.sh
   ```
   
   生成的模板将会保存在 `my_auto_template` 下。运行以下脚本以生成符合格式的 `-clean.txt` 模板。

   ```
   python tools/clean_t5_template.py --task_name tnews csl tnews ...
   ```

4. 模板评估
   




## Citation

Original implementation: [princeton-nlp/LM-BFF](https://github.com/princeton-nlp/LM-BFF)

```bibtex
@inproceedings{gao2021making,
   title={Making Pre-trained Language Models Better Few-shot Learners},
   author={Gao, Tianyu and Fisch, Adam and Chen, Danqi},
   booktitle={Association for Computational Linguistics (ACL)},
   year={2021}
}
```
