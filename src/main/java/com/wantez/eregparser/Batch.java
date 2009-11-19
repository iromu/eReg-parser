//      Copyright 2008 Ivan Rodriguez Murillo
//	
//	Licensed under the Apache License, Version 2.0 (the "License");
//	you may not use this file except in compliance with the License.
//	You may obtain a copy of the License at
//	
//	http://www.apache.org/licenses/LICENSE-2.0
//	
//	Unless required by applicable law or agreed to in writing, software
//	distributed under the License is distributed on an "AS IS" BASIS,
//	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//	See the License for the specific language governing permissions and
//	limitations under the License.

package com.wantez.eregparser;

import java.io.File;
import java.util.Date;

import org.apache.log4j.Logger;

/**
 * @author wantez
 * 
 */
public class Batch {
	private static final String BAD_PARAMETERS = "BAD PARAMETERS";
	private static final String ADAPTER_XSL = "adapter.xsl";

	public static void main(final String[] args) {
		if ((args == null) || (args.length != 4)) {
			System.err.println(Batch.BAD_PARAMETERS);
			System.exit(-1);
		}
		String importdir;
		String exportdir;
		importdir = args[1];
		exportdir = args[3];
		final Batch batch = new Batch();
		batch.run(Batch.ADAPTER_XSL, importdir, exportdir);
	}

	private final Logger log = Logger.getLogger(this.getClass());

	public void run(final String style, final String input, final String output) {
		final Parser parser = new Parser(style);
		final File in = new File(input);
		final File out = new File(output);
		final boolean isInDir = in.isDirectory();
		final boolean isOutDir = out.isDirectory();
		final long start = System.currentTimeMillis();
		this.log.info("Started at " + new Date());
		if (isInDir && isOutDir) {
			final String[] children = in.list();
			for (final String element : children) {
				final File file = new File(in, element);
				if (file.isFile()) {
					final String outPath = new File(out, element)
							.getAbsolutePath();
					final String inPath = file.getAbsolutePath();
					parser.parse(inPath, outPath);
				}
			}
		} else if (!isInDir && !isOutDir) {
			parser.parse(input, output);
		} else {
			System.err.println(Batch.BAD_PARAMETERS);
			this.log.error(Batch.BAD_PARAMETERS);
			System.exit(-1);
		}
		this.log.info("Terminated in " + (System.currentTimeMillis() - start)
				+ " ms");
	}

}
