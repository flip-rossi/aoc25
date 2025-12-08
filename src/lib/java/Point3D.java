package lib.java;

public class Point3D {
    public long x;
    public long y;
    public long z;

    public Point3D(long x, long y, long z) {
        this.x = x;
        this.y = y;
        this.z = z;
    }

    static public Point3D of(long x, long y, long z) {
        return new Point3D(x, y, z);
    }

    static public Point3D of(String xStr, String yStr, String zStr) {
        return Point3D.of(Integer.parseInt(xStr), Integer.parseInt(yStr), Integer.parseInt(zStr));
    }

    static public Point3D ofSplit(String xyzStr, String splitRegex) {
        var split = xyzStr.split(splitRegex);
        return Point3D.of(Integer.parseInt(split[0]), Integer.parseInt(split[1]), Integer.parseInt(split[2]));
    }

    public long distanceSq(Point3D other) {
        var dx = other.x - this.x;
        var dy = other.y - this.y;
        var dz = other.z - this.z;
        return dx * dx + dy * dy + dz * dz;
    }

    @Override
    public boolean equals(Object obj) {
        return obj == null
               ? false
               : this == obj
                 ? true
                 : obj instanceof Point3D other
                   ? this.x == other.x && this.y == other.y && this.z == other.z
                   : false;
    }

    @Override
    public String toString() {
        return this.toString("(", ",", ")");
    }

    public String toString(String l, String sep, String r) {
        return l + this.x + sep + this.y + sep + this.z + r;
    }
}
