import argparse
from pathlib import Path


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--seed', type=int, nargs='+', default=[13], help="Data split seeds")
    parser.add_argument('--task_name', type=str, nargs='+', default=['eprstmt', 'iflytek'], help="Task names")
    parser.add_argument('--template_dir', type=str, default="my_auto_template", help='Template directory')
    parser.add_argument('--k', type=int, default=16, help="Number of training instances per label")

    args = parser.parse_args()

    for seed in args.seed:
        for task_name in args.task_name:
            fpath = Path(f"{args.template_dir}/{task_name}/{args.k}-{seed}.txt" )
            tmps = []
            with open(fpath, 'r') as f:
                for line in f:
                    tmp_str = line.strip()
                    tmp_str = tmp_str.replace("[UNK]", "")
                    tmp_str = tmp_str.replace("[SEP]", "")
                    end = tmp_str.find("extra3")
                    if end != -1:
                        tmp_str = tmp_str[:end]
                    end = tmp_str.rfind("*")
                    tmp_str = tmp_str[:end+1]
                    tmps.append(tmp_str)
                
            with open(fpath.parent / (fpath.stem + "-clean.txt"), 'w') as f:
                for t in tmps:
                    f.write(t + '\n')


if __name__ == '__main__':
    main()